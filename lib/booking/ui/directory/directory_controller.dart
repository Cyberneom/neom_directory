import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

import '../../domain/use_cases/directory_service.dart';


class DirectoryController extends GetxController implements DirectoryService{

  final userController = Get.find<UserController>();

  AppProfile profile = AppProfile();
  Position? position;
  Address address = Address();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  bool needsPosts = false;
  bool isAdminCenter = false;

  final RxBool isButtonDisabled = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs;
  final RxMap<String, AppProfile> facilityUsers = <String, AppProfile>{}.obs;
  final RxMap<String, AppProfile> placeUsers = <String, AppProfile>{}.obs;
  final Rx<SplayTreeMap<double, AppProfile>> sortedProfileLocation = SplayTreeMap<double, AppProfile>().obs;

  @override
  void onInit() async {
    super.onInit();
    AppUtilities.logger.d("Directory Controller Init");

    profile = userController.profile;

    if(Get.arguments != null && Get.arguments.isNotEmpty) {
      isAdminCenter = Get.arguments[0] ?? false;
    }

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

      DateTime startTime = DateTime.now();
      List<AppProfile> profilesWithPhoneAndFacility = [];

      if(!isAdminCenter) {
        profilesWithPhoneAndFacility = await ProfileFirestore().getWithParameters(
            needsPhone: true, needsPosts: needsPosts,
            usageReasons: [UsageReason.professional, UsageReason.job],
            profileTypes: AppFlavour.appInUse == AppInUse.g ? [ProfileType.facilitator, ProfileType.host, ProfileType.band, ProfileType.instrumentist]
                : [ProfileType.facilitator, ProfileType.host], currentPosition: position, maxDistance: 3000
        );
      } else {
        profilesWithPhoneAndFacility = await ProfileFirestore().getWithParameters(
          needsPhone: true, needsPosts: needsPosts,
        );
      }

      DateTime endTime = DateTime.now();
      Duration duration = endTime.difference(startTime);
      AppUtilities.logger.i('Query took ${duration.inSeconds} seconds');

      for (var element in profilesWithPhoneAndFacility) {
        facilityUsers[element.id] = element;
      }

      AppUtilities.logger.i("${facilityUsers.length} Users with Facilities found");
      sortByLocation();
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    isLoading.value = false;
    update();
  }

  @override
  void sortByLocation() {
    sortedProfileLocation.value.clear();
    facilityUsers.forEach((key, mate) {
      double distanceBetweenProfiles = AppUtilities.distanceBetweenPositions(
          userController.profile.position!,
          mate.position!);

      distanceBetweenProfiles = distanceBetweenProfiles + Random().nextDouble();
      sortedProfileLocation.value[distanceBetweenProfiles] = mate;
    });
    AppUtilities.logger.i("Sorted Users ${sortedProfileLocation.value.length}");
    update([AppPageIdConstants.search]);
  }

}
