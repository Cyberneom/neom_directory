import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/neom_error_logger.dart';
import 'package:neom_core/data/firestore/profile_firestore.dart';
import 'package:neom_core/data/implementations/app_hive_controller.dart';
import 'package:neom_core/data/implementations/geolocator_controller.dart';
import 'package:neom_core/data/implementations/user_controller.dart';
import 'package:neom_core/domain/model/app_profile.dart';
import 'package:neom_core/utils/constants/app_hive_constants.dart';
import 'package:neom_core/utils/core_utilities.dart';
import 'package:neom_core/utils/enums/app_hive_box.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:neom_core/utils/enums/usage_reason.dart';
import 'package:neom_core/utils/enums/verification_level.dart';
import 'package:sint/sint.dart';

import '../../domain/use_cases/directory_service.dart';

class DirectoryController extends SintController implements DirectoryService {
  final userController = Sint.find<UserController>();
  final appHiveController = AppHiveController();

  ProfileFirestore profileFirestore = ProfileFirestore();
  final ScrollController directoryScrollController = ScrollController();
  bool isLoadingNextDirectory = false;

  AppProfile profile = AppProfile();
  Position? position;

  final RxBool needsPosts = false.obs;
  bool isAdminCenter = false;

  final RxBool isButtonDisabled = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs;
  final RxMap<double, AppProfile> directoryProfiles =
      <double, AppProfile>{}.obs;
  final RxMap<double, AppProfile> filteredProfiles = <double, AppProfile>{}.obs;
  final RxList<ProfileType> selectedProfileTypes = <ProfileType>[].obs;

  /// Immutable copy of all loaded profiles — never cleared by filters.
  /// Used as source of truth when applying/removing filters.
  Map<double, AppProfile> _allProfiles = {};

  String today = '';

  @override
  void onInit() async {
    super.onInit();
    AppConfig.logger.d("Directory Controller Init");

    profile = userController.profile;

    if (Sint.arguments != null && Sint.arguments.isNotEmpty) {
      isAdminCenter = Sint.arguments[0] ?? false;
      needsPosts.value = false;
      AppConfig.logger.d("isAdminCenter: $isAdminCenter");
    }

    directoryScrollController.addListener(_directoryScrollListener);
  }

  @override
  void onReady() async {
    super.onReady();
    AppConfig.logger.d("onReady");
    try {
      position =
          profile.position ?? await GeoLocatorController().getCurrentPosition();

      if (appHiveController.directoryLastUpdate != today) {
        AppConfig.logger.i(
          "Los datos en caché son antiguos. Cargando nuevos datos...",
        );
        await appHiveController.clearBox(AppHiveBox.directory.name);
      } else {
        AppConfig.logger.i("Cargando directoryProfiles desde caché...");
        final directoryBox = await appHiveController.getBox(
          AppHiveBox.directory.name,
        );
        var cachedProfiles = directoryBox.get(
          isAdminCenter
              ? AppHiveConstants.adminDirectoryProfiles
              : AppHiveConstants.directoryProfiles,
        );
        if (cachedProfiles != null && cachedProfiles is Map) {
          directoryProfiles.value = cachedProfiles.map(
            (key, value) => MapEntry(key, AppProfile.fromJSON(value)),
          );
        } else {
          directoryProfiles.value = {};
        }
      }

      if (directoryProfiles.isEmpty || isAdminCenter) {
        await getDirectoryProfiles();
      }

      _allProfiles = Map.from(directoryProfiles);
      filteredProfiles.assignAll(directoryProfiles);
    } catch (e, st) {
      NeomErrorLogger.recordError(e, st, module: 'neom_directory', operation: 'onReady');
    }

    isLoading.value = false;
    update();
  }

  Future<void> getDirectoryProfiles() async {
    AppConfig.logger.d("Getting Directory Profiles from Firestore");
    List<AppProfile> profilesWithPhoneAndFacility = [];

    if (isAdminCenter) {
      directoryProfiles.clear();
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
        needsPhone: true,
        currentPosition: position,
      );
    } else {
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
        needsPhone: true,
        needsPosts: needsPosts.value,
        profileTypes: ProfileType.values.where((t) => t != ProfileType.general).toList(),
        currentPosition: position,
        maxDistance: 5000,
        limit: 200,
      );
    }

    // Sort by plan tier (premium/platinum first for visibility incentive).
    final subscribedProfiles = profilesWithPhoneAndFacility
        .where((p) => p.verificationLevel.value >= VerificationLevel.basic.value)
        .toList()
      ..sort((a, b) => b.verificationLevel.value.compareTo(a.verificationLevel.value));

    // Add non-subscribed at the end (lower priority)
    final nonSubscribed = profilesWithPhoneAndFacility
        .where((p) => p.verificationLevel.value < VerificationLevel.basic.value)
        .toList();

    directoryProfiles.addAll(
      CoreUtilities.sortProfilesByLocation(
        position!,
        [...subscribedProfiles, ...nonSubscribed],
      ),
    );
    final directoryBox = await appHiveController.getBox(
      AppHiveBox.directory.name,
    );
    directoryBox.put(
      isAdminCenter
          ? AppHiveConstants.adminDirectoryProfiles
          : AppHiveConstants.directoryProfiles,
      directoryProfiles.map(
        (key, value) => MapEntry(key, value.toJSONWithFacilities()),
      ),
    );
    directoryBox.put(AppHiveConstants.lastUpdate, today);
  }

  void _directoryScrollListener() async {
    try {
      double maxScrollExtent =
          directoryScrollController.position.maxScrollExtent;

      if (directoryScrollController.offset >= maxScrollExtent &&
          !directoryScrollController.position.outOfRange &&
          !isLoadingNextDirectory) {
        AppConfig.logger.d("Directory Bottom Reached");
        isLoadingNextDirectory = true;
        update([AppPageIdConstants.directory]);

        List<AppProfile> nextProfiles = [];
        if (!isAdminCenter) {
          nextProfiles = await profileFirestore.getWithParameters(
            needsPhone: true,
            needsPosts: needsPosts.value,
            usageReasons: [UsageReason.professional],
            profileTypes: AppFlavour.getDirectoryProfileTypes(),
            currentPosition: position,
            maxDistance: 2000,
            limit: 10,
            isFirstCall: false,
          );
        } else {
          nextProfiles = await profileFirestore.getWithParameters(
            needsPhone: true,
          );
        }

        AppConfig.logger.i(
          "${nextProfiles.length} next Profiles with Facilities found",
        );
        directoryProfiles.addAll(
          CoreUtilities.sortProfilesByLocation(position!, nextProfiles),
        );
        isLoadingNextDirectory = false;
      }

      if (directoryScrollController.offset <=
              directoryScrollController.position.minScrollExtent &&
          !directoryScrollController.position.outOfRange) {
        AppConfig.logger.d("Scrolling cool");
      }
    } catch (e, st) {
      NeomErrorLogger.recordError(e, st, module: 'neom_directory', operation: '_directoryScrollListener');
    }

    update([AppPageIdConstants.directory]);
  }

  Future<void> toggleNeedsPosts() async {
    needsPosts.value = !needsPosts.value;
    directoryProfiles.clear();
    filteredProfiles.clear();
    isLoading.value = true;
    await appHiveController.clearBox(AppHiveBox.directory.name);
    await getDirectoryProfiles();
    _allProfiles = Map.from(directoryProfiles);
    filteredProfiles.assignAll(directoryProfiles);
    isLoading.value = false;
    update();
  }

  /// Toggle a category filter and immediately apply.
  void toggleProfileTypeFilter(ProfileType type) {
    AppConfig.logger.d("Toggling filter for profile type: $type");
    if (selectedProfileTypes.contains(type)) {
      selectedProfileTypes.remove(type);
    } else {
      selectedProfileTypes.add(type);
    }
    // Apply immediately — no separate "filtrar" button needed
    applyFilters();
  }

  Future<void> applyFilters() async {
    AppConfig.logger.d("Applying filters: $selectedProfileTypes");

    // Always use _allProfiles as the immutable source of truth
    final source = _allProfiles.isNotEmpty ? _allProfiles : directoryProfiles;

    // No filters selected = show ALL profiles
    if (selectedProfileTypes.isEmpty) {
      filteredProfiles.value = Map<double, AppProfile>.from(source);
      update();
      return;
    }

    // Filter by selected category types
    final result = <double, AppProfile>{};
    for (final entry in source.entries) {
      if (selectedProfileTypes.contains(entry.value.type)) {
        result[entry.key] = entry.value;
      }
    }
    AppConfig.logger.d("Filter: ${source.length} total, "
        "${result.length} match. "
        "Types in directory: ${source.values.map((p) => p.type.name).toSet()}");

    filteredProfiles.value = result;
    update();
  }

  /// Text-based search filter for web. Matches name, aboutMe, mainFeature, address.
  void filterByQuery(String query) {
    if (query.trim().isEmpty) {
      filteredProfiles.assignAll(directoryProfiles);
      return;
    }
    final q = query.toLowerCase();
    final matching = <double, AppProfile>{};
    for (final entry in directoryProfiles.entries) {
      final p = entry.value;
      final hasSkillMatch = p.skills?.values.any(
          (s) => s.name.toLowerCase().contains(q)) ?? false;
      if (p.name.toLowerCase().contains(q) ||
          p.aboutMe.toLowerCase().contains(q) ||
          p.mainFeature.toLowerCase().contains(q) ||
          p.address.toLowerCase().contains(q) ||
          hasSkillMatch) {
        matching[entry.key] = p;
      }
    }
    filteredProfiles.assignAll(matching);
  }

  /// Retorna la lista completa de tipos de perfil relevantes para el Directorio.
  List<ProfileType> getAllFilterableProfileTypes() {
    return ProfileType.values
        .where(
          (type) =>
              type != ProfileType.general &&
              type != ProfileType.researcher &&
              type != ProfileType.broadcaster,
        )
        .toList();
  }
}
