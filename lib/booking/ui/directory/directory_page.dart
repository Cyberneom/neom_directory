import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';
import 'package:neom_commons/core/utils/app_color.dart';
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
          child: _.isLoading ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              separatorBuilder:  (context, index) => const Divider(),
              itemCount: _.sortedProfileLocation.length,
              itemBuilder: (context, index) {
                return DirectoryFacility(_.sortedProfileLocation.values.elementAt(index),
                  distanceBetween: _.sortedProfileLocation.keys.elementAt(index).round().toString(),);
              }),
        ),),
      )
    );
  }

}
