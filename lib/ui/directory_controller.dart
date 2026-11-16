import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:neom_core/utils/enums/verification_level.dart';
import 'package:neom_core/utils/neom_error_logger.dart';
import 'package:sint/sint.dart';

import '../../domain/use_cases/directory_service.dart';

class DirectoryController extends SintController implements DirectoryService {
  UserController get userController => Sint.find<UserController>();
  UserController? get _userController =>
      Sint.isRegistered<UserController>() ? Sint.find<UserController>() : null;
  final AppHiveController appHiveController;

  late ProfileFirestore profileFirestore;
  final ProfileFirestore? _injectedProfileFirestore;
  final ScrollController directoryScrollController = ScrollController();
  bool isLoadingNextDirectory = false;

  DirectoryController({
    AppHiveController? hiveController,
    ProfileFirestore? firestore,
  })  : appHiveController = hiveController ?? AppHiveController(),
        _injectedProfileFirestore = firestore;

  ProfileFirestore get _profileFirestore =>
      _injectedProfileFirestore ?? profileFirestore;

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

  static const int maxSearchQueryChars = 120;
  static final RegExp _controlAndBidiRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u0085\u061C\u200B\u200C\u200E\u200F\u2028-\u202E\u2060-\u2069\uFEFF]',
  );
  static final RegExp _gemmaThoughtBlock = RegExp(
    r'<\|(?:channel|turn)>\s*thought\b[\s\S]*?<(?:channel|turn)\|>'
    r'|<\|tool_call>[\s\S]*?<tool_call\|>',
    caseSensitive: false,
  );
  static final RegExp _gemmaThoughtTruncated = RegExp(
    r'<\|(?:channel|turn)>\s*thought\b[\s\S]*$'
    r'|<\|tool_call>[\s\S]*$',
    caseSensitive: false,
  );
  static final RegExp _internalTagBlock = RegExp(
    r'<\s*(think|thinking|thought|memory_recall|auto_memory|system_context)\b[^>]*>[\s\S]*?<\s*/\s*\1\s*>'
    r'|\[\s*(BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\b[^\]]*\](?:(?!\[\s*\2\b)[\s\S])*?\[\s*/\s*\2\s*\]',
    caseSensitive: false,
  );
  static final RegExp _internalTagTruncated = RegExp(
    r'<\s*(think|thinking|thought|memory_recall|auto_memory|system_context)\b[^>]*>[\s\S]*$',
    caseSensitive: false,
  );
  static final RegExp _danglingInternalTag = RegExp(
    r'<\s*/?\s*(think|thinking|thought|memory_recall|auto_memory|system_context)\b[^>]*>'
    r'|<\|/?(?:turn|channel|eot|eot_id|im_start|im_end|tool_call)\|?>'
    r'|<(?:turn|channel|tool_call)\|>'
    r'|\[\s*/?\s*(?:BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\b[^\]]*\]',
    caseSensitive: false,
  );
  static final RegExp _closingContentTagRe = RegExp(
    r'<\s*/\s*content\s*>',
    caseSensitive: false,
  );

  /// Sanitizes a directory search query, stripping Gemma-4/internal reasoning
  /// blocks, Bidi/zero-width controls, and truncating UTF-16 surrogate-safely.
  static String sanitizeSearchQuery(String query) {
    if (query.isEmpty) return '';
    var cleaned = query
        .replaceAll(_gemmaThoughtBlock, ' ')
        .replaceAll(_gemmaThoughtTruncated, ' ')
        .replaceAll(_internalTagBlock, ' ')
        .replaceAll(_internalTagTruncated, ' ')
        .replaceAll(_danglingInternalTag, ' ')
        .replaceAll(_closingContentTagRe, '[content_end]')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(_controlAndBidiRe, '')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
    if (cleaned.length > maxSearchQueryChars) {
      var end = maxSearchQueryChars;
      final cu = cleaned.codeUnitAt(end - 1);
      if (cu >= 0xD800 && cu <= 0xDBFF) end -= 1;
      cleaned = end <= 0 ? '' : cleaned.substring(0, end);
    }
    return cleaned.toLowerCase();
  }

  bool _isClosed = false;

  /// Immutable copy of all loaded profiles — never cleared by filters.
  /// Used as source of truth when applying/removing filters.
  Map<double, AppProfile> _allProfiles = {};
  String _activeSearchQuery = '';

  String today = _computeTodayKey();

  static String _computeTodayKey([DateTime? now]) {
    final dt = now ?? DateTime.now();
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  /// Sorts [profiles] by distance from [position] when geolocation is available,
  /// or assigns deterministic synthetic keys without throwing `Null check operator`
  /// when location permission is denied or unavailable (Web/Desktop).
  static Map<double, AppProfile> sortOrIndexProfiles(
    Position? currentPosition,
    List<AppProfile> profiles, {
    int indexOffset = 0,
  }) {
    if (profiles.isEmpty) return <double, AppProfile>{};
    if (currentPosition != null) {
      return CoreUtilities.sortProfilesByLocation(currentPosition, profiles);
    }
    final fallback = <double, AppProfile>{};
    for (var i = 0; i < profiles.length; i++) {
      // Negative synthetic keys distinguish unknown-distance entries while
      // preserving tier priority ordering without colliding with real >=0 km keys.
      final syntheticKey = -(indexOffset + i + 1).toDouble();
      fallback[syntheticKey] = profiles[i];
    }
    return fallback;
  }

  @override
  void onInit() {
    super.onInit();
    AppConfig.logger.d('Directory Controller Init');
    today = _computeTodayKey();
    if (_injectedProfileFirestore == null) {
      try {
        profileFirestore = ProfileFirestore();
      } catch (_) {}
    } else {
      profileFirestore = _injectedProfileFirestore;
    }

    profile = _userController?.profile ?? AppProfile();

    final args = Sint.arguments;
    if (args is List && args.isNotEmpty) {
      isAdminCenter = args[0] == true;
      needsPosts.value = false;
      AppConfig.logger.d('isAdminCenter: $isAdminCenter');
    } else if (args is bool) {
      isAdminCenter = args;
      needsPosts.value = false;
    } else if (args is Map && args['isAdminCenter'] is bool) {
      isAdminCenter = args['isAdminCenter'] as bool;
      needsPosts.value = false;
    }

    directoryScrollController.addListener(_directoryScrollListener);
  }

  @override
  void onReady() async {
    super.onReady();
    AppConfig.logger.d('onReady');
    try {
      position =
          profile.position ?? await GeoLocatorController().getCurrentPosition();

      if (appHiveController.directoryLastUpdate != today) {
        AppConfig.logger.i(
          'Los datos en caché son antiguos. Cargando nuevos datos...',
        );
        await appHiveController.clearBox(AppHiveBox.directory.name);
      } else {
        AppConfig.logger.i('Cargando directoryProfiles desde caché...');
        final directoryBox = await appHiveController.getBox(
          AppHiveBox.directory.name,
        );
        final cachedProfiles = directoryBox.get(
          isAdminCenter
              ? AppHiveConstants.adminDirectoryProfiles
              : AppHiveConstants.directoryProfiles,
        );
        if (cachedProfiles is Map) {
          final parsed = <double, AppProfile>{};
          cachedProfiles.forEach((rawKey, rawVal) {
            final key = rawKey is num
                ? rawKey.toDouble()
                : double.tryParse(rawKey.toString());
            if (key != null && key.isFinite && rawVal is Map) {
              parsed[key] = AppProfile.fromJSON(rawVal);
            }
          });
          directoryProfiles.value = parsed;
        } else {
          directoryProfiles.value = {};
        }
      }

      if (directoryProfiles.isEmpty || isAdminCenter) {
        await getDirectoryProfiles();
      }
      if (_isClosed || isClosed) return;

      _allProfiles = Map.from(directoryProfiles);
      filteredProfiles.assignAll(directoryProfiles);
    } catch (e, st) {
      NeomErrorLogger.recordError(
        e,
        st,
        module: 'neom_directory',
        operation: 'onReady',
      );
    }

    if (!_isClosed && !isClosed) {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getDirectoryProfiles() async {
    AppConfig.logger.d('Getting Directory Profiles from Firestore');
    List<AppProfile> profilesWithPhoneAndFacility = [];

    if (isAdminCenter) {
      directoryProfiles.clear();
      profilesWithPhoneAndFacility = await _profileFirestore.getWithParameters(
        needsPhone: true,
        currentPosition: position,
      );
    } else {
      profilesWithPhoneAndFacility = await _profileFirestore.getWithParameters(
        needsPhone: true,
        needsPosts: needsPosts.value,
        profileTypes: ProfileType.values
            .where((t) => t != ProfileType.general)
            .toList(),
        currentPosition: position,
        maxDistance: 5000,
        limit: 200,
      );
    }

    // Sort by plan tier (premium/platinum first for visibility incentive).
    final subscribedProfiles = profilesWithPhoneAndFacility
        .where(
          (p) => p.verificationLevel.value >= VerificationLevel.basic.value,
        )
        .toList()
      ..sort(
        (a, b) =>
            b.verificationLevel.value.compareTo(a.verificationLevel.value),
      );

    // Add non-subscribed at the end (lower priority)
    final nonSubscribed = profilesWithPhoneAndFacility
        .where((p) => p.verificationLevel.value < VerificationLevel.basic.value)
        .toList();

    directoryProfiles.addAll(
      sortOrIndexProfiles(
        position,
        [...subscribedProfiles, ...nonSubscribed],
        indexOffset: directoryProfiles.length,
      ),
    );
    final directoryBox = await appHiveController.getBox(
      AppHiveBox.directory.name,
    );
    await directoryBox.put(
      isAdminCenter
          ? AppHiveConstants.adminDirectoryProfiles
          : AppHiveConstants.directoryProfiles,
      directoryProfiles.map(
        (key, value) => MapEntry(key, value.toJSONWithFacilities()),
      ),
    );
    await directoryBox.put(AppHiveConstants.lastUpdate, today);
  }

  void _directoryScrollListener() async {
    if (!directoryScrollController.hasClients) return;
    try {
      final double maxScrollExtent =
          directoryScrollController.position.maxScrollExtent;

      if (directoryScrollController.offset >= maxScrollExtent &&
          !directoryScrollController.position.outOfRange &&
          !isLoadingNextDirectory) {
        AppConfig.logger.d('Directory Bottom Reached');
        isLoadingNextDirectory = true;
        update([AppPageIdConstants.directory]);

        try {
          List<AppProfile> nextProfiles = [];
          if (!isAdminCenter) {
            nextProfiles = await _profileFirestore.getWithParameters(
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
            nextProfiles = await _profileFirestore.getWithParameters(
              needsPhone: true,
            );
          }

          AppConfig.logger.i(
            '${nextProfiles.length} next Profiles with Facilities found',
          );
          if (_isClosed || isClosed) return;
          directoryProfiles.addAll(
            sortOrIndexProfiles(
              position,
              nextProfiles,
              indexOffset: directoryProfiles.length,
            ),
          );
          _allProfiles = Map.from(directoryProfiles);
          await applyFilters();
        } finally {
          isLoadingNextDirectory = false;
        }
      }
    } catch (e, st) {
      NeomErrorLogger.recordError(
        e,
        st,
        module: 'neom_directory',
        operation: '_directoryScrollListener',
      );
    }

    if (!_isClosed && !isClosed) {
      update([AppPageIdConstants.directory]);
    }
  }

  Future<void> toggleNeedsPosts() async {
    if (_isClosed || isClosed) return;
    needsPosts.value = !needsPosts.value;
    directoryProfiles.clear();
    filteredProfiles.clear();
    isLoading.value = true;
    await appHiveController.clearBox(AppHiveBox.directory.name);
    await getDirectoryProfiles();
    if (_isClosed || isClosed) return;
    _allProfiles = Map.from(directoryProfiles);
    await applyFilters();
    if (_isClosed || isClosed) return;
    isLoading.value = false;
    update();
  }

  /// Toggle a category filter and immediately apply.
  void toggleProfileTypeFilter(ProfileType type) {
    if (_isClosed || isClosed) return;
    AppConfig.logger.d('Toggling filter for profile type: $type');
    if (selectedProfileTypes.contains(type)) {
      selectedProfileTypes.remove(type);
    } else {
      selectedProfileTypes.add(type);
    }
    applyFilters();
  }

  Future<void> applyFilters() async {
    if (_isClosed || isClosed) return;
    AppConfig.logger.d('Applying filters: $selectedProfileTypes');

    final source = _allProfiles.isNotEmpty ? _allProfiles : directoryProfiles;
    final q = _activeSearchQuery;

    final result = <double, AppProfile>{};
    for (final entry in source.entries) {
      final p = entry.value;
      if (selectedProfileTypes.isNotEmpty &&
          !selectedProfileTypes.contains(p.type)) {
        continue;
      }
      if (q.isNotEmpty && !_profileMatchesQuery(p, q)) {
        continue;
      }
      result[entry.key] = p;
    }

    filteredProfiles.value = result;
    update();
  }

  static bool _profileMatchesQuery(AppProfile p, String q) {
    final hasSkillMatch =
        p.skills?.values.any((s) => s.name.toLowerCase().contains(q)) ?? false;
    return p.name.toLowerCase().contains(q) ||
        p.aboutMe.toLowerCase().contains(q) ||
        p.mainFeature.toLowerCase().contains(q) ||
        p.address.toLowerCase().contains(q) ||
        hasSkillMatch;
  }

  /// Text-based search filter for web. Matches name, aboutMe, mainFeature, address.
  void filterByQuery(String query) {
    if (_isClosed || isClosed) return;
    _activeSearchQuery = sanitizeSearchQuery(query);
    applyFilters();
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

  @override
  void onClose() {
    _isClosed = true;
    directoryScrollController.removeListener(_directoryScrollListener);
    directoryScrollController.dispose();
    needsPosts.close();
    isButtonDisabled.close();
    isLoading.close();
    isUploading.close();
    directoryProfiles.close();
    filteredProfiles.close();
    selectedProfileTypes.close();
    super.onClose();
  }
}
