import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_assets.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_static_img_urls.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'Widgets/booking_widgets.dart';
import 'booking_controller.dart';

class BookingHomePage extends StatelessWidget {
  const BookingHomePage({super.key});

    @override
    Widget build(BuildContext context) {
      return GetBuilder<BookingController>(
        id: AppPageIdConstants.booking,
        init: BookingController(),
        builder: (_) => Scaffold(
          backgroundColor: AppColor.main50,
          // appBar: AppBarBooking(),
          body: SingleChildScrollView(
              child: Container(
                decoration: AppTheme.appBoxDecoration,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                              ),
                             child: Image.asset(AppAssets.bookingLanding,
                                 fit: BoxFit.fill,
                               colorBlendMode: BlendMode.colorBurn,
                               filterQuality: FilterQuality.high,
                             ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AppTheme.heightSpace20,
                              Center(
                                child: Text(_.address.country.toLowerCase().tr.capitalize,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight:FontWeight.w900,
                                    color: AppColor.getMain(),
                                    //foreground: GigAppTheme.getTextForeGround(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0, bottom: 0,
                            left: 0, right: 0,
                            child: MaterialButton(
                              onPressed: () {
                                Get.toNamed(AppRouteConstants.directory);
                              },
                              elevation: 3,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 40),
                                  margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.white,
                                  ),
                                  child: Text(AppTranslationConstants.explore.tr.toUpperCase(),
                                    style: const TextStyle(color: AppColor.ceriseRed, fontWeight: FontWeight.bold),
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    AppTheme.heightSpace20,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: AppColor.main25,
                      height: 400,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text(AppConstants.anthonyRojasCOO,
                                  style: TextStyle(color:AppColor.ceriseRed,
                                      fontWeight: FontWeight.bold)
                                )
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
                            child: Text(AppTranslationConstants.bookingWelcome.tr,
                              style: const TextStyle(fontSize: 13)),
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _.animationController,
                              builder: (BuildContext context, Widget? child) {
                              return PageView(
                                scrollDirection: Axis.horizontal,
                                controller: _.pageController,
                                children: <Widget>[
                                  buildScrollActivities(AppTranslationConstants.rehearsalRoom.tr, AppStaticImageUrls.rehearsalRoom),
                                  buildScrollActivities(AppTranslationConstants.liveSessions.tr, AppStaticImageUrls.liveSessions),
                                  buildScrollActivities(AppTranslationConstants.homeStudio.tr, AppStaticImageUrls.homeStudio),
                                  buildScrollActivities(AppTranslationConstants.production.tr, AppStaticImageUrls.production),
                                  buildScrollActivities(AppTranslationConstants.forums.tr, AppStaticImageUrls.forums),
                                  buildScrollActivities(AppTranslationConstants.recordStudio.tr, AppStaticImageUrls.recordStudio)
                                ],);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ),
        )
      );
    }

  }
