import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/app_circular_progress_indicator.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';

import '../utils/constants/directory_translation_constants.dart';
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
      builder: (controller) => Scaffold(
        appBar: controller.isAdminCenter ? AppBarChild(title: CommonTranslationConstants.usersDirectory.tr, color: Colors.transparent) : AppBarChild(title: DirectoryTranslationConstants.businessDirectory.tr, color: Colors.transparent),
        backgroundColor: AppColor.main75,
        body: Obx(()=> SafeArea(
          child: controller.isLoading.value ? AppCircularProgressIndicator(subtitle: controller.isAdminCenter ? CommonTranslationConstants.usersDirectory : DirectoryTranslationConstants.businessDirectory.tr,)
              : Stack(
              children: [
                controller.profilesToShow.value.isNotEmpty ? ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  separatorBuilder:  (context, index) => const Divider(),
                  itemCount: controller.profilesToShow.value.length,
                  controller: controller.directoryScrollController,
                  itemBuilder: (context, index) {
                    return DirectoryFacility(controller.profilesToShow.value.values.elementAt(index),
                      distanceBetween: controller.profilesToShow.value.keys.elementAt(index).round().toString(),);
                  }) :
                Center(
                  child: SizedBox(
                    width: AppTheme.fullWidth(context)*0.75,
                    child:  Text(DirectoryTranslationConstants.noNearResultsWereFound.tr,
                      style: AppTheme.primaryTitleText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if(controller.isLoadingNextDirectory)
                  const Center(child: CircularProgressIndicator())
              ]
          )
        )
        )
      )
    );
  }

}
