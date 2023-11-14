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
  Address address = Address();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  final RxBool isButtonDisabled = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs;
  final RxMap<String, AppUser> facilityUsers = <String, AppUser>{}.obs;
  final RxMap<String, AppUser> placeUsers = <String, AppUser>{}.obs;
  final Rx<SplayTreeMap<double, AppUser>> sortedProfileLocation = SplayTreeMap<double, AppUser>().obs;

  late Position _position;

  @override
  void onInit() async {
    super.onInit();
    AppUtilities.logger.d("Directory Controller Init");

    profile = userController.profile;

    try {
      _position = await GeoLocatorController().getCurrentPosition();
      List<AppUser> usersWithPhoneAndFacility = await UserFirestore().getWithParameters(
          needsPhone: true, includeProfile: true,
          profileTypes: [ProfileType.facilitator, ProfileType.host, ProfileType.instrumentist, ProfileType.band],
          usageReasons: [UsageReason.professional, UsageReason.job],
          currentPosition: _position, maxDistance: 15000
      );

      for (var element in usersWithPhoneAndFacility) {
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
    facilityUsers.forEach((key, usermate) {
      double distanceBetweenProfiles = AppUtilities.distanceBetweenPositions(
          userController.profile.position!,
          usermate.profiles.first.position!);

      distanceBetweenProfiles = distanceBetweenProfiles + Random().nextDouble();
      sortedProfileLocation.value[distanceBetweenProfiles] = usermate;
    });

    AppUtilities.logger.i("Sortered Users ${sortedProfileLocation.value.length}");
    update([AppPageIdConstants.search]);
  }

}
