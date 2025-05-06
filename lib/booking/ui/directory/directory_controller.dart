
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_commons/core/data/implementations/app_hive_controller.dart';
import 'package:neom_commons/core/utils/constants/app_hive_constants.dart';
import 'package:neom_commons/core/utils/enums/app_hive_box.dart';
import 'package:neom_commons/neom_commons.dart';

import '../../domain/use_cases/directory_service.dart';


class DirectoryController extends GetxController implements DirectoryService{

  final userController = Get.find<UserController>();
  final appHiveController = AppHiveController();

  ProfileFirestore profileFirestore = ProfileFirestore();
  final ScrollController directoryScrollController = ScrollController();
  bool isLoadingNextDirectory = false;

  AppProfile profile = AppProfile();
  Position? position;
  // Address address = Address();
  // TextEditingController locationController = TextEditingController();
  // TextEditingController captionController = TextEditingController();
  bool needsPosts = false;
  bool isAdminCenter = false;

  final RxBool isButtonDisabled = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs;
  final RxMap<double, AppProfile> profilesToShow = <double, AppProfile>{}.obs;

  String today = '';
  //TODO TO USE WHEN FILTERING
  // final RxMap<String, AppProfile> facilityProfiles = <String, AppProfile>{}.obs;
  // final RxMap<String, AppProfile> placeProfiles = <String, AppProfile>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    AppUtilities.logger.d("Directory Controller Init");

    profile = userController.profile;

    if(Get.arguments != null && Get.arguments.isNotEmpty) {
      isAdminCenter = Get.arguments[0] ?? false;
    }

    directoryScrollController.addListener(_directoryScrollListener);

    try {
      needsPosts = !isAdminCenter;
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

  }

  @override
  void onReady() async {
    super.onReady();
    AppUtilities.logger.d("onReady");
    try {
      position = profile.position ?? await GeoLocatorController().getCurrentPosition();

      List<AppProfile> profilesWithPhoneAndFacility = [];

      if (appHiveController.directoryLastUpdate != today) {
        AppUtilities.logger.i("Los datos en caché son antiguos. Cargando nuevos datos...");
        await appHiveController.clearBox(AppHiveBox.directory.name);
      } else {
        AppUtilities.logger.i("Cargando directoryProfiles desde caché...");
        var cachedProfiles = Hive.box(AppHiveBox.directory.name).get(AppHiveConstants.directoryProfiles);
        if (cachedProfiles != null && cachedProfiles is Map) {
          profilesToShow.value = cachedProfiles.map((key, value) => MapEntry(key, AppProfile.fromJSON(value)));
        } else {
          profilesToShow.value = {};
        }
      }

      if(profilesToShow.isEmpty) await getProfilesToShow(profilesWithPhoneAndFacility);
      
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    isLoading.value = false;
    update();
  }

  Future<void> getProfilesToShow(List<AppProfile> profilesWithPhoneAndFacility) async {
    if(!isAdminCenter) {
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
          needsPhone: true, needsPosts: needsPosts,
          // usageReasons: [UsageReason.professional, UsageReason.any],
          ///DEPRECATED profileTypes: [ProfileType.facilitator, ProfileType.host, ProfileType.band, ProfileType.artist],
          currentPosition: position,
          maxDistance: 2000, limit: 100
      );
    } else {
      profilesWithPhoneAndFacility = await profileFirestore.getWithParameters(
        needsPhone: true, currentPosition: position
      );
    }
    
    profilesToShow.addAll(CoreUtilities.sortProfilesByLocation(position!, profilesWithPhoneAndFacility));
    Hive.box(AppHiveBox.directory.name).put(AppHiveConstants.directoryProfiles,
        profilesToShow.map((key, value) => MapEntry(key, value.toJSONWithFacilities())));
    Hive.box(AppHiveBox.directory.name).put(AppHiveConstants.lastUpdate, today);
  }

  void _directoryScrollListener() async {
    try {

      double maxScrollExtent = directoryScrollController.position.maxScrollExtent;

      if (directoryScrollController.offset >= maxScrollExtent
          && !directoryScrollController.position.outOfRange
          && !isLoadingNextDirectory
      ) {
        AppUtilities.logger.d("Directory Bottom Reached");
        isLoadingNextDirectory = true;
        update([AppPageIdConstants.directory]);

        List<AppProfile> nextProfiles = [];
        if(!isAdminCenter) {
          nextProfiles = await profileFirestore.getWithParameters(
              needsPhone: true, needsPosts: needsPosts,
              usageReasons: [UsageReason.professional],
              profileTypes: AppFlavour.appInUse == AppInUse.g ? [ProfileType.facilitator, ProfileType.host, ProfileType.band, ProfileType.appArtist]
                  : [ProfileType.facilitator, ProfileType.host], currentPosition: position, maxDistance: 2000, limit: 10, isFirstCall: false,
          );
        } else {
          nextProfiles = await profileFirestore.getWithParameters(
            needsPhone: true,
          );
        }

        AppUtilities.logger.i("${nextProfiles.length} next Profiles with Facilities found");
        profilesToShow.addAll(CoreUtilities.sortProfilesByLocation(position!, nextProfiles));
        isLoadingNextDirectory = false;
      }

      if (directoryScrollController.offset <= directoryScrollController.position.minScrollExtent &&
          !directoryScrollController.position.outOfRange) {
        AppUtilities.logger.d("Scrolling cool");
      }
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    update([AppPageIdConstants.directory]);
  }

}
