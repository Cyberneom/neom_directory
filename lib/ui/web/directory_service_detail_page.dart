import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/widgets/custom_image.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/external_utilities.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/domain/model/app_profile.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import '../../utils/constants/directory_translation_constants.dart';

/// Fiverr-style service detail page.
///
/// Layout:
/// ┌──────────────────────────────┬──────────────────────┐
/// │  Breadcrumb                  │                      │
/// │  Title                       │  [Básico|Estándar|   │
/// │  Avatar + Name + Rating      │   Premium]           │
/// │                              │  Price               │
/// │  [Gallery Carousel]          │  Description         │
/// │                              │  [Contactar]         │
/// │  About this service          │                      │
/// │  ...                         │  [Contáctame]        │
/// └──────────────────────────────┴──────────────────────┘
///
/// DO NOT MODIFY without consulting Fiverr reference (March 2026).
class DirectoryServiceDetailPage extends StatefulWidget {
  const DirectoryServiceDetailPage({super.key});

  @override
  State<DirectoryServiceDetailPage> createState() => _DirectoryServiceDetailPageState();
}

class _DirectoryServiceDetailPageState extends State<DirectoryServiceDetailPage> {
  int _selectedPackage = 0; // 0=Básico, 1=Estándar, 2=Premium
  int _currentGalleryIndex = 0;

  AppProfile get _profile {
    final args = Sint.arguments;
    if (args != null && args is AppProfile) return args;
    return AppProfile();
  }

  List<String> get _galleryImages {
    final urls = <String>[];
    if (_profile.coverImgUrl.isNotEmpty) urls.add(_profile.coverImgUrl);
    for (final facility in (_profile.facilities?.values ?? [])) {
      for (final u in facility.galleryImgUrls) {
        if (u != null && u.toString().isNotEmpty) urls.add(u.toString());
      }
    }
    if (urls.isEmpty && _profile.photoUrl.isNotEmpty) urls.add(_profile.photoUrl);
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final p = _profile;
    final gallery = _galleryImages;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + Breadcrumb
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white70),
                        onPressed: () => Sint.back(),
                      ),
                      Text(AppTranslationConstants.directory.tr,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      Icon(Icons.chevron_right, size: 16, color: Colors.grey[600]),
                      Text(p.mainFeature.isNotEmpty ? p.mainFeature : p.type.name,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main content: left (gallery + info) + right (pricing card)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ═══ LEFT: Gallery + About ═══
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              p.aboutMe.isNotEmpty ? p.aboutMe.split('\n').first : p.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Avatar + Name + Rating
                            Row(
                              children: [
                                platformCircleAvatar(
                                  imageUrl: p.photoUrl.isNotEmpty ? p.photoUrl : AppProperties.getAppLogoUrl(),
                                  radius: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(p.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                // Rating
                                if (p.reviewStars > 0) ...[
                                  Icon(Icons.star, size: 14, color: Colors.amber[600]),
                                  const SizedBox(width: 2),
                                  Text('${(p.reviewStars / 2).toStringAsFixed(1)}',
                                      style: TextStyle(color: Colors.amber[600], fontSize: 13)),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Gallery carousel
                            if (gallery.isNotEmpty)
                              _buildGallery(gallery),

                            const SizedBox(height: 24),

                            // About
                            if (p.aboutMe.isNotEmpty) ...[
                              const Text('Sobre este profesional',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Text(p.aboutMe,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.6)),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(width: 32),

                      // ═══ RIGHT: Pricing card ═══
                      SizedBox(
                        width: 340,
                        child: _buildPricingCard(p),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(List<String> images) {
    return Column(
      children: [
        // Main image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: platformNetworkImage(
                  imageUrl: images[_currentGalleryIndex],
                  fit: BoxFit.cover,
                ),
              ),
              // Nav arrows
              if (images.length > 1) ...[
                Positioned(
                  left: 8, top: 0, bottom: 0,
                  child: Center(
                    child: _galleryArrow(Icons.chevron_left, () {
                      setState(() => _currentGalleryIndex =
                          (_currentGalleryIndex - 1).clamp(0, images.length - 1));
                    }),
                  ),
                ),
                Positioned(
                  right: 8, top: 0, bottom: 0,
                  child: Center(
                    child: _galleryArrow(Icons.chevron_right, () {
                      setState(() => _currentGalleryIndex =
                          (_currentGalleryIndex + 1).clamp(0, images.length - 1));
                    }),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Thumbnails
        if (images.length > 1)
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setState(() => _currentGalleryIndex = i),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: i == _currentGalleryIndex ? AppColor.bondiBlue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: platformNetworkImage(imageUrl: images[i], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _galleryArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildPricingCard(AppProfile p) {
    final packages = [
      DirectoryTranslationConstants.packageBasic.tr,
      DirectoryTranslationConstants.packageStandard.tr,
      'Premium',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        children: [
          // Package tabs
          Row(
            children: List.generate(3, (i) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPackage = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == _selectedPackage ? AppColor.bondiBlue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    packages[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: i == _selectedPackage ? Colors.white : Colors.grey[500],
                      fontSize: 14,
                      fontWeight: i == _selectedPackage ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            )),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package name
                Text(packages[_selectedPackage].toUpperCase(),
                    style: TextStyle(color: Colors.grey[500], fontSize: 11, letterSpacing: 1)),
                const SizedBox(height: 8),

                // Price placeholder (from profile or default)
                Text(
                  DirectoryTranslationConstants.contactForPricing.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Service description
                Text(
                  p.mainFeature.isNotEmpty ? p.mainFeature : p.aboutMe.split('\n').first,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Location
                if (p.address.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(p.address, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),

                const SizedBox(height: 20),

                // CTA button — Continuar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.bondiBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // Navigate to inbox/message
                      Sint.toNamed(AppRouteConstants.inbox);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DirectoryTranslationConstants.continueAction.tr,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Contact button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (p.phoneNumber.isNotEmpty) {
                        ExternalUtilities.launchWhatsappURL(p.phoneNumber, '');
                      } else {
                        Sint.toNamed(AppRouteConstants.inbox);
                      }
                    },
                    child: Text(DirectoryTranslationConstants.contactMe.tr,
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
