import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

class BookingController extends GetxController with GetTickerProviderStateMixin {

  var logger = AppUtilities.logger;
  final userController = Get.find<UserController>();

  final RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => _isButtonDisabled.value = isButtonDisabled;

  final RxInt _sliderPage = 0.obs;
  int get sliderPage => _sliderPage.value;
  set sliderPage(int sliderPage) => _sliderPage.value = sliderPage;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => _isLoading.value = isLoading;

  final RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  set isUploading(bool isUploading) => _isUploading.value = isUploading;

  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  AppProfile profile = AppProfile();
  Address address = Address();

  Position? _position;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  late AnimationController animationController;

  @override
  void onInit() async {
    super.onInit();
    logger.d("Booking Controller Init");

    profile = userController.profile;
    animationController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this
    )..repeat();

    try {
      _position = await GeoLocatorController().getCurrentPosition();
      getAddressFromLocation();
    } catch (e) {
      logger.e(e.toString());
    }

    // if(pageController.hasClients){
    //   pageController.animateToPage(
    //     4,
    //     duration: Duration(milliseconds: 1300),
    //     curve: Curves.easeIn,
    //   );
    // }

  }


  @override
  void onReady() async {

  }

  @override
  void onClose() {
    animationController.dispose();
  }

  void getAddressFromLocation() async {
    if(_position != null) {
      address = await Address.getAddressFromPosition(_position!);
    }
    update([AppPageIdConstants.booking]);
  }

}
