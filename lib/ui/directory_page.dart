import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/app_circular_progress_indicator.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/domain/model/app_profile.dart';

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
        appBar:  AppBarChild(
          title: controller.isAdminCenter
              ? CommonTranslationConstants.usersDirectory.tr
              :  DirectoryTranslationConstants.businessDirectory.tr,
          color: Colors.transparent,
          titleSpacing: 15,
          actionWidgets: [
            Obx(() => IconButton(
              icon: Icon(
                controller.selectedProfileTypes.isEmpty
                    ? Icons.filter_list_outlined
                    : Icons.filter_list_off_outlined,
              ),
              onPressed: () => _showFilterModal(context, controller),
            )),
          ],
        ),
        backgroundColor: AppColor.main75,
        body: Obx(()=> SafeArea(
          child: controller.isLoading.value ? AppCircularProgressIndicator(subtitle: controller.isAdminCenter ? CommonTranslationConstants.usersDirectory : DirectoryTranslationConstants.businessDirectory.tr,)
              : Stack(
              children: [
                controller.directoryProfiles.value.isNotEmpty ?
                buildDirectoryProfilesListView(controller.filteredProfiles.isNotEmpty ? controller.filteredProfiles : controller.directoryProfiles, controller: controller)
                : Center(
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

  ListView buildDirectoryProfilesListView(Map<double, AppProfile> directoryProfiles, {required DirectoryController controller}) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        separatorBuilder:  (context, index) => const Divider(),
        itemCount: directoryProfiles.length,
        controller: controller.directoryScrollController,
        itemBuilder: (context, index) {
          return DirectoryFacility(directoryProfiles.values.elementAt(index),
            distanceBetween: directoryProfiles.keys.elementAt(index).round().toString(),);
        });
  }

  // 6. Método para mostrar el modal de filtro
  void _showFilterModal(BuildContext context, DirectoryController controller) {
    Get.bottomSheet(
      Obx(() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.getMain(),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Filtrar por Tipo de Perfil",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.white30),
            ...controller.getAllFilterableProfileTypes().map((type) {
              return CheckboxListTile(
                title: Text(type.name.tr.capitalize, style: const TextStyle(color: Colors.white)),
                value: controller.selectedProfileTypes.contains(type),
                onChanged: (bool? newValue) {
                  controller.toggleProfileTypeFilter(type);
                },
                activeColor: AppColor.bondiBlue75,
                checkColor: Colors.white,
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.applyFilters();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.bondiBlue75,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Aplicar Filtros (${controller.selectedProfileTypes.length} seleccionados)",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      )),
      isScrollControlled: true,
    );
  }

}
