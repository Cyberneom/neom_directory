import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/custom_image.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:sint/sint.dart';

import '../../utils/constants/directory_translation_constants.dart';
import '../directory_controller.dart';
import 'widgets/directory_web_card.dart';
import 'widgets/directory_web_filter_sidebar.dart';

/// Fiverr/Upwork-style directory page for web.
///
/// Layout:
/// ┌─────────────┬──────────────────────────────────────┐
/// │  FILTERS    │  SEARCH BAR                          │
/// │  sidebar    ├──────────────────────────────────────┤
/// │             │  PROFESSIONAL CARDS GRID             │
/// │  Categories │  [Card] [Card] [Card]                │
/// │  Distance   │  [Card] [Card] [Card]                │
/// │             │  ...                                  │
/// └─────────────┴──────────────────────────────────────┘
class DirectoryWebPage extends StatelessWidget {
  final DirectoryController controller;

  const DirectoryWebPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppFlavour.getBackgroundColor(),
      body: Container(
        decoration: AppTheme.appBoxDecoration,
        child: Column(
          children: [
            // Top bar with search
            _buildTopBar(context),
            // Main content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter sidebar
                  SizedBox(
                    width: 240,
                    child: DirectoryWebFilterSidebar(controller: controller),
                  ),
                  // Vertical divider
                  VerticalDivider(width: 1, color: AppColor.borderSubtle),
                  // Grid content
                  Expanded(
                    child: Column(
                      children: [
                        // CTA banner for non-subscribers
                        if (controller.userController.user.subscriptionId.isEmpty)
                          _buildCtaBanner(context),
                        Expanded(child: _buildGrid(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Sint.back(),
          ),
          const SizedBox(width: 12),
          Text(
            AppTranslationConstants.directory.tr,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          // Search bar
          SizedBox(
            width: 400,
            height: 40,
            child: TextField(
              onChanged: (q) => controller.filterByQuery(q),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: '${AppTranslationConstants.search.tr}...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                filled: true,
                fillColor: Colors.white.withAlpha(8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withAlpha(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withAlpha(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColor.bondiBlue.withAlpha(100)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      final profiles = controller.filteredProfiles;

      if (profiles.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[700]),
              const SizedBox(height: 12),
              Text(AppTranslationConstants.noResults.tr,
                  style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            ],
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossCount = constraints.maxWidth > 1200
              ? 4
              : constraints.maxWidth > 900
                  ? 3
                  : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: profiles.length,
            itemBuilder: (_, i) {
              final p = profiles.values.elementAt(i);
              return DirectoryWebCard(
                profile: p,
                onTap: () => Sint.toNamed(
                  AppRouteConstants.matePath(p.id),
                  arguments: p.id,
                ),
                onLongPress: () => Sint.toNamed(
                  '/directory/service',
                  arguments: p,
                ),
              );
            },
          );
        },
      );
    });
  }

  /// CTA banner for users without active subscription.
  Widget _buildCtaBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Sint.toNamed(AppRouteConstants.subscriptionPlans),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DirectoryTranslationConstants.ctaTitle.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DirectoryTranslationConstants.ctaSubtitle.tr,
                      style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DirectoryTranslationConstants.ctaButton.tr,
                  style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
