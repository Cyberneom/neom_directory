import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/app_circular_progress_indicator.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/app_translation_constants.dart';

import 'directory_controller.dart';
import 'widgets/directory_facility.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<DirectoryController>();
    return GetBuilder<DirectoryController>(
      id: AppPageIdConstants.directory,
      init: DirectoryController(),
      builder: (_) => Scaffold(
        appBar: _.isAdminCenter ? AppBarChild(title: AppTranslationConstants.usersDirectory.tr, color: Colors.transparent) : AppBarChild(title: AppTranslationConstants.businessDirectory.tr, color: Colors.transparent),
        backgroundColor: AppColor.main75,
        body: Obx(()=> SafeArea(
          child: _.isLoading.value ? AppCircularProgressIndicator(subtitle: _.isAdminCenter ? AppTranslationConstants.usersDirectory : AppTranslationConstants.businessDirectory.tr,)
              : Stack(
              children: [
                _.profilesToShow.value.isNotEmpty ? ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  separatorBuilder:  (context, index) => const Divider(),
                  itemCount: _.profilesToShow.value.length,
                  controller: _.directoryScrollController,
                  itemBuilder: (context, index) {
                    return DirectoryFacility(_.profilesToShow.value.values.elementAt(index),
                      distanceBetween: _.profilesToShow.value.keys.elementAt(index).round().toString(),);
                  }) :
                Center(
                  child: SizedBox(
                    width: AppTheme.fullWidth(context)*0.75,
                    child:  Text(AppTranslationConstants.noNearResultsWereFound.tr,
                      style: AppTheme.primaryTitleText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if(_.isLoadingNextDirectory)
                  const Center(child: CircularProgressIndicator())
              ]
          )
        )
        )
      )
    );
  }

}
