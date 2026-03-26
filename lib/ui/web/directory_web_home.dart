import 'package:flutter/material.dart';
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/custom_image.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:sint/sint.dart';

import '../../utils/constants/directory_translation_constants.dart';
import '../directory_controller.dart';

/// Fiverr-style directory home — hero + search + categories + popular services.
///
/// DO NOT MODIFY THIS LAYOUT without consulting the design reference.
/// Based on Fiverr's landing page pattern (March 2026).
class DirectoryWebHome extends StatelessWidget {
  final DirectoryController controller;

  const DirectoryWebHome({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHero(context),
          const SizedBox(height: 40),
          _buildCategoryRow(context),
          const SizedBox(height: 48),
          _buildPopularServices(context),
          const SizedBox(height: 48),
          _buildFooter(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Hero section with search bar.
  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.surfaceElevated,
            Colors.deepPurple.withAlpha(30),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Text(
                DirectoryTranslationConstants.heroTitle.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: controller.filterByQuery,
                        style: const TextStyle(color: Colors.black87, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: DirectoryTranslationConstants.searchHint.tr,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.bondiBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.search, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Category icons row (like Fiverr's service categories).
  Widget _buildCategoryRow(BuildContext context) {
    final categories = [
      _CategoryItem(
        icon: Icons.edit,
        label: DirectoryTranslationConstants.catWriter.tr,
        type: ProfileType.appArtist,
        color: Colors.purple,
      ),
      _CategoryItem(
        icon: Icons.design_services,
        label: DirectoryTranslationConstants.catDesigner.tr,
        type: ProfileType.facilitator,
        color: Colors.teal,
      ),
      _CategoryItem(
        icon: Icons.auto_fix_high,
        label: DirectoryTranslationConstants.catEditor.tr,
        type: ProfileType.facilitator,
        color: Colors.blue,
      ),
      _CategoryItem(
        icon: Icons.brush,
        label: DirectoryTranslationConstants.catIllustrator.tr,
        type: ProfileType.facilitator,
        color: Colors.orange,
      ),
      _CategoryItem(
        icon: Icons.campaign,
        label: DirectoryTranslationConstants.catMarketing.tr,
        type: ProfileType.facilitator,
        color: Colors.pink,
      ),
      _CategoryItem(
        icon: Icons.mic,
        label: DirectoryTranslationConstants.catNarrator.tr,
        type: ProfileType.appArtist,
        color: Colors.amber,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.map((cat) => _buildCategoryIcon(cat)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(_CategoryItem cat) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          controller.selectedProfileTypes.clear();
          controller.selectedProfileTypes.add(cat.type);
          controller.applyFilters();
        },
        child: Column(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(12)),
              ),
              child: Icon(cat.icon, color: cat.color.withAlpha(180), size: 28),
            ),
            const SizedBox(height: 8),
            Text(cat.label,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  /// Popular services horizontal scroll (like Fiverr's colored cards).
  Widget _buildPopularServices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DirectoryTranslationConstants.popularServices.tr,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Obx(() {
              final topProfiles = controller.directoryProfiles.values
                  .where((p) => p.type == ProfileType.appArtist || p.type == ProfileType.facilitator)
                  .take(8)
                  .toList();

              if (topProfiles.isEmpty) {
                return Center(child: Text(
                  AppTranslationConstants.noResults.tr,
                  style: TextStyle(color: Colors.grey[600]),
                ));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topProfiles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => _buildPopularCard(topProfiles[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCard(dynamic profile) {
    final colors = [Colors.deepPurple, Colors.teal, Colors.pink, Colors.orange, Colors.blue];
    final color = colors[profile.name.hashCode.abs() % colors.length];
    final coverUrl = profile.coverImgUrl.isNotEmpty ? profile.coverImgUrl : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Sint.toNamed('/compa/${profile.id}'),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(40)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover or color block
              Expanded(
                child: coverUrl.isNotEmpty
                    ? platformNetworkImage(imageUrl: coverUrl, fit: BoxFit.cover)
                    : Container(
                        color: color.withAlpha(15),
                        child: Center(child: Icon(Icons.person, size: 40, color: color.withAlpha(60))),
                      ),
              ),
              // Name + category
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(profile.mainFeature.isNotEmpty ? profile.mainFeature : profile.type.name,
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        '${AppProperties.getAppName()} ${DirectoryTranslationConstants.businessDirectory.tr}',
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final ProfileType type;
  final Color color;

  _CategoryItem({required this.icon, required this.label, required this.type, required this.color});
}
