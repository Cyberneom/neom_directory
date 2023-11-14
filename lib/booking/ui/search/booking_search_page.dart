import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/constants/message_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/facilitator_type.dart';

class BookingSearchPage extends StatelessWidget {

  const BookingSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarChild(title: AppTranslationConstants.filter.tr),
      body: SingleChildScrollView(
          child: Container(
            decoration: AppTheme.appBoxDecoration,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppTranslationConstants.type.tr.toUpperCase(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    for(var facility in FacilityType.values)
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: CheckboxListTile(
                          activeColor: AppColor.bondiBlue,
                          title: Text(facility.value.tr.capitalizeFirst),
                          value: false,
                          onChanged: (value){
                            AppUtilities.showSnackBar(
                              title: MessageTranslationConstants.underConstruction.tr,
                              message: MessageTranslationConstants.featureAvailableSoon.tr,
                            );
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        color: AppColor.main75,
                        elevation: 6,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRouteConstants.bookingSearch);
                          },
                          splashColor: AppColor.white80,
                          hoverColor: AppColor.yellow,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(AppTranslationConstants.search.tr,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppTheme.heightSpace20
                  ],
                ),
              ),
        ),
      );
  }
}
