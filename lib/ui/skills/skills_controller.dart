import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/data/firestore/profile_firestore.dart';
import 'package:neom_core/domain/model/profile_skill.dart';
import 'package:neom_core/domain/use_cases/user_service.dart';
import 'package:neom_core/utils/constants/data_assets.dart';
import 'package:neom_core/utils/enums/experience_level.dart';
import 'package:sint/sint.dart';

class SkillsController extends SintController {

  static const int maxSkills = 10;

  final allSkills = <ProfileSkill>[].obs;
  final profileSkills = <String, ProfileSkill>{}.obs;
  final searchQuery = ''.obs;
  final isLoading = true.obs;
  final portfolioUrl = ''.obs;

  final _profileFirestore = ProfileFirestore();

  UserService get _userService => Sint.find<UserService>();
  String get _profileId => _userService.profile.id;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await _loadSkillsFromAsset();
      // Load current profile data
      final current = _userService.profile.skills;
      if (current != null && current.isNotEmpty) {
        profileSkills.value = Map<String, ProfileSkill>.from(current);
      }
      portfolioUrl.value = _userService.profile.portfolioUrl;
    } catch (e) {
      AppConfig.logger.e('Error loading skills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSkillsFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString(DataAssets.userSkillsJsonPath);
      final List<dynamic> jsonList = json.decode(jsonStr);
      allSkills.value = jsonList
          .map((e) => ProfileSkill.fromJsonDefault(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      AppConfig.logger.e('Error loading freelance expertise JSON: $e');
    }
  }

  List<ProfileSkill> get filteredSkills {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return allSkills;
    return allSkills.where((s) =>
      s.name.toLowerCase().contains(query) ||
      s.description.toLowerCase().contains(query)
    ).toList();
  }

  bool isSkillAdded(String skillName) => profileSkills.containsKey(skillName);

  bool get canAddMore => profileSkills.length < maxSkills;

  Future<bool> addSkill(ProfileSkill skill, ExperienceLevel level, {double price = 0}) async {
    if (!canAddMore) return false;
    if (isSkillAdded(skill.name)) return false;

    final newSkill = ProfileSkill(
      id: skill.name,
      name: skill.name,
      description: skill.description,
      experienceLevel: level,
      price: price,
    );

    profileSkills[skill.name] = newSkill;
    _userService.profile.skills = Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> removeSkill(String skillName) async {
    profileSkills.remove(skillName);
    _userService.profile.skills = Map<String, ProfileSkill>.from(profileSkills);
    return _persistSkills();
  }

  Future<bool> updateSkillLevel(String skillName, ExperienceLevel level) async {
    final skill = profileSkills[skillName];
    if (skill == null) return false;

    skill.experienceLevel = level;
    profileSkills[skillName] = skill;
    profileSkills.refresh();
    _userService.profile.skills = Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> updateSkillPrice(String skillName, double price) async {
    final skill = profileSkills[skillName];
    if (skill == null) return false;

    skill.price = price;
    profileSkills[skillName] = skill;
    profileSkills.refresh();
    _userService.profile.skills = Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> savePortfolioUrl(String url) async {
    portfolioUrl.value = url;
    _userService.profile.portfolioUrl = url;
    return _profileFirestore.updatePortfolioUrl(_profileId, url);
  }

  Future<bool> _persistSkills() async {
    final skillsMap = profileSkills.map((key, value) => MapEntry(key, value.toJSON()));
    return _profileFirestore.updateSkills(_profileId, skillsMap);
  }
}
