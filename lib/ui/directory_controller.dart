
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/app_config.dart';
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

  bool needsPosts = true;
  bool isAdminCenter = false;

  final RxBool isButtonDisabled = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs;
  final RxMap<double, AppProfile> directoryProfiles = <double, AppProfile>{}.obs;
  final RxMap<double, AppProfile> filteredProfiles = <double, AppProfile>{}.obs;
  final RxList<ProfileType> selectedProfileTypes = <ProfileType>[].obs;

  String today = '';

  @override
  void onInit() async {
    super.onInit();
    AppConfig.logger.d("Directory Controller Init");

    profile = userController.profile;

    if(Sint.arguments != null && Sint.arguments.isNotEmpty) {
      isAdminCenter = Sint.arguments[0] ?? false;
      needsPosts = false;
      AppConfig.logger.d("isAdminCenter: $isAdminCenter");
    }

    directoryScrollController.addListener(_directoryScrollListener);

  }

  @override
  void onReady() async {
    super.onReady();
    AppConfig.logger.d("onReady");
    try {
      position = profile.position ?? await GeoLocatorController().getCurrentPosition();

      if (appHiveController.directoryLastUpdate != today) {
        AppConfig.logger.i("Los datos en caché son antiguos. Cargando nuevos datos...");
        await appHiveController.clearBox(AppHiveBox.directory.name);
      } else {
        AppConfig.logger.i("Cargando directoryProfiles desde caché...");
        var cachedProfiles = Hive.box(AppHiveBox.directory.name)
            .get(isAdminCenter ? AppHiveConstants.adminDirectoryProfiles : AppHiveConstants.directoryProfiles);
        if (cachedProfiles != null && cachedProfiles is Map) {
          directoryProfiles.value = cachedProfiles.map((key, value) => MapEntry(key, AppProfile.fromJSON(value)));
        } else {
          directoryProfiles.value = {};
        }
      }

      if(directoryProfiles.isEmpty || isAdminCenter) await getDirectoryProfiles();
      
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    isLoading.value = false;
    update();
  }

  Future<void> getDirectoryProfiles() async {
    AppConfig.logger.d("Getting Directory Profiles from Firestore");
    List<AppProfile> profilesWithPhoneAndFacility = [];

    if(isAdminCenter) {
      directoryProfiles.clear();
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
          needsPhone: true, currentPosition: position
      );
    } else {
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
          needsPhone: true, needsPosts: needsPosts,
          profileTypes: [ProfileType.appArtist, ProfileType.host, ProfileType.band, ProfileType.facilitator],
          currentPosition: position,
          maxDistance: 2000, limit: 100
      );
    }
    
    directoryProfiles.addAll(CoreUtilities.sortProfilesByLocation(position!, profilesWithPhoneAndFacility));
    Hive.box(AppHiveBox.directory.name).put(isAdminCenter ? AppHiveConstants.adminDirectoryProfiles : AppHiveConstants.directoryProfiles,
        directoryProfiles.map((key, value) => MapEntry(key, value.toJSONWithFacilities())));
    Hive.box(AppHiveBox.directory.name).put(AppHiveConstants.lastUpdate, today);
  }

  void _directoryScrollListener() async {
    try {

      double maxScrollExtent = directoryScrollController.position.maxScrollExtent;

      if (directoryScrollController.offset >= maxScrollExtent
          && !directoryScrollController.position.outOfRange
          && !isLoadingNextDirectory
      ) {
        AppConfig.logger.d("Directory Bottom Reached");
        isLoadingNextDirectory = true;
        update([AppPageIdConstants.directory]);

        List<AppProfile> nextProfiles = [];
        if(!isAdminCenter) {
          nextProfiles = await profileFirestore.getWithParameters(
              needsPhone: true, needsPosts: needsPosts,
              usageReasons: [UsageReason.professional],
              profileTypes: AppFlavour.getDirectoryProfileTypes(), currentPosition: position, maxDistance: 2000, limit: 10, isFirstCall: false,
          );
        } else {
          nextProfiles = await profileFirestore.getWithParameters(
            needsPhone: true,
          );
        }

        AppConfig.logger.i("${nextProfiles.length} next Profiles with Facilities found");
        directoryProfiles.addAll(CoreUtilities.sortProfilesByLocation(position!, nextProfiles));
        isLoadingNextDirectory = false;
      }

      if (directoryScrollController.offset <= directoryScrollController.position.minScrollExtent &&
          !directoryScrollController.position.outOfRange) {
        AppConfig.logger.d("Scrolling cool");
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    update([AppPageIdConstants.directory]);
  }

  void toggleProfileTypeFilter(ProfileType type) {
    AppConfig.logger.d("Toggling filter for profile type: $type");
    if (selectedProfileTypes.contains(type)) {
      selectedProfileTypes.remove(type);
    } else {
      selectedProfileTypes.add(type);
    }
  }

  Future<void> applyFilters() async {
    AppConfig.logger.d("Applying filters: $selectedProfileTypes");
    List<AppProfile> matchingProfiles = [];

    isLoading.value = true;
    filteredProfiles.clear();

    if(selectedProfileTypes.isNotEmpty) {
      for (AppProfile profile in directoryProfiles.values) {
        if(selectedProfileTypes.contains(profile.type)) {
          matchingProfiles.add(profile);
        }
      }
      filteredProfiles.addAll(CoreUtilities.sortProfilesByLocation(position!, matchingProfiles));
    }

    isLoading.value = false;
  }

  /// Retorna la lista completa de tipos de perfil relevantes para el Directorio.
  List<ProfileType> getAllFilterableProfileTypes() {

    return ProfileType.values
        .where((type) => type != ProfileType.general && type != ProfileType.researcher && type != ProfileType.broadcaster)
        .toList();
  }

}
