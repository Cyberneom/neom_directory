import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';


class DirectoryController extends GetxController {

  var logger = AppUtilities.logger;
  final userController = Get.find<UserController>();

  final RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => _isButtonDisabled.value = isButtonDisabled;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => _isLoading.value = isLoading;

  final RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  set isUploading(bool isUploading) => _isUploading.value = isUploading;

  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  AppProfile profile = AppProfile();
  Address address = Address();

  late Position _position;

  final RxMap<String, AppUser> _facilityUsers = <String, AppUser>{}.obs;
  Map<String, AppUser> get facilityUsers => _facilityUsers;
  set facilityUsers(Map<String, AppUser> facilityUsers) => _facilityUsers.value = facilityUsers;

  final RxMap<String, AppUser> _placeUsers = <String, AppUser>{}.obs;
  Map<String, AppUser> get placeUsers => _placeUsers;
  set placeUsers(Map<String, AppUser> placeUsers) => _placeUsers.value = placeUsers;

  final Rx<SplayTreeMap<double, AppUser>> _sortedProfileLocation = SplayTreeMap<double, AppUser>().obs;
  SplayTreeMap<double, AppUser> get sortedProfileLocation => _sortedProfileLocation.value;
  set sortedProfileLocation(SplayTreeMap<double, AppUser> sortedProfileLocation) => _sortedProfileLocation.value = sortedProfileLocation;

  @override
  void onInit() async {
    super.onInit();
    logger.d("Directory Controller Init");

    profile = userController.profile;

    try {
      _position = await GeoLocatorController().getCurrentPosition();
      List<AppUser> usersWithPhoneAndFacility = await UserFirestore().getWithParameters(
          needsPhone: true, includeProfile: true,
          profileTypes: [ProfileType.facilitator, ProfileType.host], currentPosition: _position,
      maxDistance: 15000);

      for (var element in usersWithPhoneAndFacility) {
        facilityUsers[element.id] = element;
      }

      AppUtilities.logger.i("${facilityUsers.length} Users with Facilitys found");
      sortByLocation();
    } catch (e) {
      logger.e(e.toString());
    }

    isLoading = false;
    update();

  }

  @override
  void sortByLocation() {
    sortedProfileLocation.clear();
    facilityUsers.forEach((key, usermate) {
      double distanceBetweenProfiles = AppUtilities.distanceBetweenPositions(
          userController.profile.position!,
          usermate.profiles.first.position!);

      distanceBetweenProfiles = distanceBetweenProfiles + Random().nextDouble();
      sortedProfileLocation[distanceBetweenProfiles] = usermate;
    });

    logger.i("Sortered Users ${sortedProfileLocation.length}");
    update([AppPageIdConstants.search]);
  }

}
