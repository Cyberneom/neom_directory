import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/app_circular_progress_indicator.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'directory_controller.dart';
import 'directory_facility.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DirectoryController>(
      id: AppPageIdConstants.directory,
      init: DirectoryController(),
      builder: (_) => Scaffold(
        appBar: AppBarChild(title: AppTranslationConstants.businessDirectory.tr,color: Colors.transparent),
        backgroundColor: AppColor.main75,
        body: Obx(()=>SafeArea(
          child: _.isLoading.value ? const AppCircularProgressIndicator()
              : _.sortedProfileLocation.value.isNotEmpty ? ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              separatorBuilder:  (context, index) => const Divider(),
              itemCount: _.sortedProfileLocation.value.length,
              itemBuilder: (context, index) {
                return DirectoryFacility(_.sortedProfileLocation.value.values.elementAt(index),
                  distanceBetween: _.sortedProfileLocation.value.keys.elementAt(index).round().toString(),);
              }) : Center(
                  child:SizedBox(
                    width: AppTheme.fullWidth(context)*0.75,
                    child:  Text(AppTranslationConstants.noNearResultsWereFound.tr,
                    style: AppTheme.primaryTitleText,
                    textAlign: TextAlign.center,
                  ),
                ),
          ),
        )
        )
      )
    );
  }

}
