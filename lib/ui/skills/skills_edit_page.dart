import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_core/domain/model/profile_skill.dart';
import 'package:neom_core/utils/enums/experience_level.dart';
import 'package:sint/sint.dart';

import '../../utils/constants/directory_translation_constants.dart';
import 'skills_controller.dart';

class SkillsEditPage extends StatelessWidget {
  const SkillsEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SintBuilder<SkillsController>(
      init: SkillsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.scaffold,
          appBar: SintAppBar(
            title: DirectoryTranslationConstants.skillsAndExpertise.tr,
            backgroundColor: AppColor.surfaceElevated,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Portfolio / Website section
                    _PortfolioSection(controller: controller),
                    const SizedBox(height: 32),

                    // Header
                    Text(
                      DirectoryTranslationConstants.skillsAndExpertise.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Add new button
                    _AddNewButton(controller: controller),
                    const SizedBox(height: 16),

                    // Current skills grid
                    if (controller.profileSkills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            DirectoryTranslationConstants.noSkillsYet.tr,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: controller.profileSkills.entries.map((entry) {
                          return _SkillCard(
                            skill: entry.value,
                            onRemove: () => controller.removeSkill(entry.key),
                            onChangeLevel: (level) => controller.updateSkillLevel(entry.key, level),
                            onChangePrice: (price) => controller.updateSkillPrice(entry.key, price),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _PortfolioSection extends StatefulWidget {
  final SkillsController controller;
  const _PortfolioSection({required this.controller});

  @override
  State<_PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<_PortfolioSection> {
  late TextEditingController _urlCtrl;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: widget.controller.portfolioUrl.value);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portfolio / Website',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('(Optional)',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
          const SizedBox(height: 16),
          TextField(
            controller: _urlCtrl,
            onChanged: (_) => setState(() => _saved = false),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'mypersonalwebsite.com',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
              prefixIcon: const Icon(Icons.link, color: Colors.white38, size: 20),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderMedium),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderMedium),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () async {
                await widget.controller.savePortfolioUrl(_urlCtrl.text.trim());
                if (mounted) setState(() => _saved = true);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _saved ? Colors.greenAccent : Colors.white70,
                side: BorderSide(color: _saved ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.white24),
              ),
              child: Text(_saved ? 'Saved' : 'Add'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  final SkillsController controller;
  const _AddNewButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canAdd = controller.canAddMore;
      return OutlinedButton.icon(
        onPressed: canAdd ? () => _showAddSkillDialog(context, controller) : null,
        icon: Icon(Icons.add, color: canAdd ? Colors.white70 : Colors.white24),
        label: Text(
          canAdd
            ? DirectoryTranslationConstants.addNew.tr
            : DirectoryTranslationConstants.maxSkillsReached.tr,
          style: TextStyle(color: canAdd ? Colors.white70 : Colors.white24),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: canAdd ? Colors.white24 : Colors.white12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    });
  }
}

class _SkillCard extends StatefulWidget {
  final ProfileSkill skill;
  final VoidCallback onRemove;
  final ValueChanged<ExperienceLevel> onChangeLevel;
  final ValueChanged<double> onChangePrice;

  const _SkillCard({
    required this.skill,
    required this.onRemove,
    required this.onChangeLevel,
    required this.onChangePrice,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  late TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(
      text: widget.skill.price > 0 ? widget.skill.price.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.skill.name,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white38, size: 20),
                color: AppColor.surfaceElevated,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  if (value == 'remove') {
                    widget.onRemove();
                  } else if (value.startsWith('level_')) {
                    final level = ExperienceLevel.values.firstWhere(
                      (l) => l.name == value.substring(6),
                      orElse: () => ExperienceLevel.beginner,
                    );
                    widget.onChangeLevel(level);
                  }
                },
                itemBuilder: (_) => [
                  ...ExperienceLevel.values.map((level) => PopupMenuItem(
                    value: 'level_${level.name}',
                    child: Row(
                      children: [
                        Icon(
                          widget.skill.experienceLevel == level ? Icons.radio_button_checked : Icons.radio_button_off,
                          size: 16,
                          color: widget.skill.experienceLevel == level ? _levelColor(level) : Colors.white38,
                        ),
                        const SizedBox(width: 8),
                        Text(_levelLabel(level), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Text(DirectoryTranslationConstants.removeSkill.tr,
                            style: const TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _levelLabel(widget.skill.experienceLevel),
            style: TextStyle(color: _levelColor(widget.skill.experienceLevel), fontSize: 12),
          ),
          const SizedBox(height: 8),
          // Price field
          SizedBox(
            width: 120,
            height: 36,
            child: TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              onSubmitted: (v) {
                final price = double.tryParse(v) ?? 0;
                widget.onChangePrice(price);
              },
              onChanged: (v) {
                final price = double.tryParse(v) ?? 0;
                widget.onChangePrice(price);
              },
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColor.borderMedium),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColor.borderMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _levelLabel(ExperienceLevel level) {
  switch (level) {
    case ExperienceLevel.beginner:
      return DirectoryTranslationConstants.beginner.tr;
    case ExperienceLevel.intermediate:
      return DirectoryTranslationConstants.intermediate.tr;
    case ExperienceLevel.pro:
      return DirectoryTranslationConstants.pro.tr;
  }
}

Color _levelColor(ExperienceLevel level) {
  switch (level) {
    case ExperienceLevel.beginner:
      return Colors.grey;
    case ExperienceLevel.intermediate:
      return Colors.amber;
    case ExperienceLevel.pro:
      return Colors.greenAccent;
  }
}

void _showAddSkillDialog(BuildContext context, SkillsController controller) {
  final searchCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final selectedLevel = ExperienceLevel.beginner.obs;

  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: AppColor.scaffold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 550),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.add, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text(DirectoryTranslationConstants.addNew.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.bondiBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColor.bondiBlue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DirectoryTranslationConstants.searchSkill.tr,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search field
              TextField(
                controller: searchCtrl,
                onChanged: (v) => controller.searchQuery.value = v,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: DirectoryTranslationConstants.searchSkill.tr,
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                  filled: true,
                  fillColor: AppColor.surfaceCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.borderMedium),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.borderMedium),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 8),

              // Experience level selector
              Obx(() => Row(
                children: [
                  Text('${DirectoryTranslationConstants.experienceLevel.tr}: ',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                  const SizedBox(width: 8),
                  ...ExperienceLevel.values.map((level) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(_levelLabel(level), style: TextStyle(
                        color: selectedLevel.value == level ? Colors.black : Colors.white70,
                        fontSize: 11,
                      )),
                      selected: selectedLevel.value == level,
                      onSelected: (_) => selectedLevel.value = level,
                      selectedColor: _levelColor(level),
                      backgroundColor: AppColor.surfaceCard,
                      side: BorderSide(color: AppColor.borderMedium),
                      visualDensity: VisualDensity.compact,
                    ),
                  )),
                ],
              )),
              const SizedBox(height: 8),

              // Price field
              Row(
                children: [
                  Text('Precio: ',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    height: 34,
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        filled: true,
                        fillColor: AppColor.surfaceCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: AppColor.borderMedium),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: AppColor.borderMedium),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Skills list
              Expanded(
                child: Obx(() {
                  final skills = controller.filteredSkills;
                  if (skills.isEmpty) {
                    return Center(
                      child: Text('Sin resultados', style: TextStyle(color: Colors.white.withValues(alpha: 0.3))),
                    );
                  }
                  return ListView.separated(
                    itemCount: skills.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                    itemBuilder: (_, i) {
                      final skill = skills[i];
                      final isAdded = controller.isSkillAdded(skill.name);
                      return ListTile(
                        dense: true,
                        title: Text(skill.name, style: TextStyle(
                          color: isAdded ? Colors.white38 : Colors.white,
                          fontSize: 14,
                        )),
                        subtitle: skill.description.isNotEmpty
                            ? Text(skill.description, style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3), fontSize: 11))
                            : null,
                        trailing: isAdded
                            ? const Icon(Icons.check, color: Colors.greenAccent, size: 18)
                            : null,
                        onTap: isAdded ? null : () async {
                          final price = double.tryParse(priceCtrl.text) ?? 0;
                          final added = await controller.addSkill(skill, selectedLevel.value, price: price);
                          if (added && ctx.mounted) {
                            Navigator.of(ctx).pop();
                          }
                        },
                      );
                    },
                  );
                }),
              ),

              // Cancel button
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(AppTranslationConstants.cancel.tr, style: const TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
