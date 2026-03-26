import 'package:flutter/material.dart';
import 'package:neom_commons/ui/widgets/custom_image.dart';
import 'package:neom_core/domain/model/app_profile.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:neom_core/utils/enums/experience_level.dart';
import 'package:neom_core/utils/enums/verification_level.dart';
import 'package:sint/sint.dart';

/// Fiverr-style professional card for the web directory grid.
///
/// Layout:
/// ┌──────────────────────────┐
/// │  [Cover/Gallery Image]   │
/// │                          │
/// ├──────────────────────────┤
/// │  [Avatar] Name           │
/// │  📍 Location             │
/// │  🏷️ Category badge       │
/// │  ⭐ Rating               │
/// │                          │
/// │  "Short bio excerpt..."  │
/// │                          │
/// │  [Contactar]             │
/// └──────────────────────────┘
class DirectoryWebCard extends StatefulWidget {
  final AppProfile profile;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const DirectoryWebCard({
    super.key,
    required this.profile,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<DirectoryWebCard> createState() => _DirectoryWebCardState();
}

class _DirectoryWebCardState extends State<DirectoryWebCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    final hasGallery = (p.facilities?.values ?? []).any((f) => f.galleryImgUrls.isNotEmpty);
    final galleryUrl = hasGallery
        ? (p.facilities?.values ?? []).firstWhere((f) => f.galleryImgUrls.isNotEmpty).galleryImgUrls.first
        : '';
    final coverUrl = p.coverImgUrl.isNotEmpty
        ? p.coverImgUrl
        : galleryUrl.isNotEmpty
            ? galleryUrl
            : '';
    final avatarUrl = p.photoUrl.isNotEmpty ? p.photoUrl : AppProperties.getAppLogoUrl();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(_isHovered ? 12 : 5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? Colors.white24 : Colors.white.withAlpha(8),
            ),
            boxShadow: _isHovered
                ? [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    coverUrl.isNotEmpty
                        ? platformNetworkImage(imageUrl: coverUrl, fit: BoxFit.cover)
                        : Container(
                            color: _profileTypeColor(p.type).withAlpha(20),
                            child: Center(
                              child: Icon(
                                _profileTypeIcon(p.type),
                                size: 40,
                                color: _profileTypeColor(p.type).withAlpha(80),
                              ),
                            ),
                          ),
                    // Gradient fade at bottom
                    Positioned(
                      bottom: 0, left: 0, right: 0, height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withAlpha(120)],
                          ),
                        ),
                      ),
                    ),
                    // Category badge
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _profileTypeColor(p.type).withAlpha(200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (p.mainFeature.isNotEmpty ? p.mainFeature.tr : p.type.name.tr).capitalize,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Plan tier badge (top right) — incentivizes upgrades
                    if (p.verificationLevel.value >= VerificationLevel.creator.value)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _planBadgeColor(p.verificationLevel),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium, size: 10,
                                  color: p.verificationLevel.value >= VerificationLevel.premium.value
                                      ? Colors.amber : Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                _planDisplayName(p.verificationLevel),
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Profile info
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar + Name row
                      Row(
                        children: [
                          platformCircleAvatar(imageUrl: avatarUrl, radius: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location
                      if (p.address.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                p.address,
                                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 4),

                      // Bio excerpt
                      if (p.aboutMe.isNotEmpty)
                        Text(
                          p.aboutMe,
                          style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),

                      // Skills chips
                      if (p.skills != null && p.skills!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: p.skills!.values.take(3).map((skill) {
                            final color = skill.experienceLevel == ExperienceLevel.pro
                                ? Colors.greenAccent
                                : skill.experienceLevel == ExperienceLevel.intermediate
                                    ? Colors.amber
                                    : Colors.grey;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: color.withValues(alpha: 0.25)),
                              ),
                              child: Text(
                                  skill.price > 0 ? '${skill.name} · ${skill.priceDisplay}' : skill.name,
                                  style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w500)),
                            );
                          }).toList(),
                        ),
                      ],

                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _profileTypeColor(ProfileType type) {
    switch (type) {
      case ProfileType.appArtist: return Colors.purple;
      case ProfileType.facilitator: return Colors.teal;
      case ProfileType.host: return Colors.orange;
      case ProfileType.band: return Colors.blue;
      default: return Colors.grey;
    }
  }

  Color _planBadgeColor(VerificationLevel level) {
    switch (level) {
      case VerificationLevel.platinum: return Colors.deepPurple;
      case VerificationLevel.premium: return Colors.amber.shade800;
      case VerificationLevel.professional: return Colors.blue.shade700;
      case VerificationLevel.artist: return Colors.pink.shade700;
      case VerificationLevel.ambassador: return Colors.teal.shade700;
      case VerificationLevel.creator: return Colors.grey.shade700;
      default: return Colors.grey.shade800;
    }
  }

  String _planDisplayName(VerificationLevel level) {
    final key = '${level.name}Plan';
    final translated = key.tr;
    if (translated != key) {
      // Strip "Plan" prefix/suffix for badge display (e.g. "Plan Posiciónate" → "Posiciónate")
      return translated
          .replaceFirst(RegExp(r'^Plan\s+', caseSensitive: false), '')
          .replaceFirst(RegExp(r'\s*plan$', caseSensitive: false), '')
          .toUpperCase();
    }
    return level.name.toUpperCase();
  }

  IconData _profileTypeIcon(ProfileType type) {
    switch (type) {
      case ProfileType.appArtist: return Icons.edit;
      case ProfileType.facilitator: return Icons.handyman;
      case ProfileType.host: return Icons.event;
      case ProfileType.band: return Icons.people;
      default: return Icons.person;
    }
  }
}
