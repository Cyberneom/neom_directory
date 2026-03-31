import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:sint/sint.dart';

import '../../../utils/constants/directory_translation_constants.dart';
import '../../directory_controller.dart';

/// Filter sidebar for the web directory — categories + apply button.
class DirectoryWebFilterSidebar extends StatelessWidget {
  final DirectoryController controller;

  const DirectoryWebFilterSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslationConstants.filter.tr,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Category header
          Text(
            DirectoryTranslationConstants.category.tr,
            style: TextStyle(color: Colors.grey[500], fontSize: 11,
                letterSpacing: 1, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Profile type chips
          Obx(() => Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTypeChip(ProfileType.appArtist, Icons.edit, Colors.purple),
              _buildTypeChip(ProfileType.facilitator, Icons.handyman, Colors.teal),
              _buildTypeChip(ProfileType.host, Icons.event, Colors.orange),
              //TODO When bands | collectives | tribes have accounts.
              // _buildTypeChip(ProfileType.band, Icons.people, Colors.blue),
            ],
          )),

          const SizedBox(height: 12),

          // Clear filter button (only when filters active)
          Obx(() => controller.selectedProfileTypes.isNotEmpty
              ? TextButton.icon(
                  icon: const Icon(Icons.clear, color: Colors.white38, size: 16),
                  label: Text(AppTranslationConstants.clear.tr,
                      style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  onPressed: () {
                    controller.selectedProfileTypes.clear();
                    controller.applyFilters();
                  },
                )
              : const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // Stats
          Obx(() => Text(
            '${controller.filteredProfiles.length} ${DirectoryTranslationConstants.professionals.tr}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          )),
        ],
      ),
    );
  }

  Widget _buildTypeChip(ProfileType type, IconData icon, Color color) {
    final isSelected = controller.selectedProfileTypes.contains(type);
    return GestureDetector(
      onTap: () => controller.toggleProfileTypeFilter(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.white.withAlpha(5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color.withAlpha(120) : Colors.white.withAlpha(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? color : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              type.name.tr,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[500],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
