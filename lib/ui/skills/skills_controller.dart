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
  static const double maxSkillPrice = 1000000;

  static final RegExp _controlAndBidiRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u0085\u061C\u200B-\u200F\u2028-\u202E\u2060-\u2069\uFEFF]',
  );
  static final RegExp _rawUrlUnsafeRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u0085\u061C\u200B-\u200F\u2028-\u202E\u2060-\u2069\uFEFF\u3002\uFF0E\uFF61\\]',
  );
  static final RegExp _encodedUrlBidiRe = RegExp(
    r'%(?:e2%80%(?:8[b-f]|a[8-e])|e2%81%(?:a[0-9])|d8%9c|ef%bb%bf|c2%85)',
    caseSensitive: false,
  );
  static final RegExp _canonicalIpv4Re = RegExp(
    r'^(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}$',
  );
  static final RegExp _numericOrHexIpv4LikeRe = RegExp(
    r'^(?:0x[0-9a-f]+|\d+)(?:\.(?:0x[0-9a-f]+|\d+)){0,3}$',
    caseSensitive: false,
  );
  static final RegExp _safeProfileIdRe = RegExp(r'^[A-Za-z0-9._:-]{1,128}$');
  static final RegExp _reservedIdRe = RegExp(r'^__.*__$');
  static final RegExp _encodedIdTraversalRe = RegExp(
    r'%(?:2e|2f|5c|00|25)',
    caseSensitive: false,
  );
  static final RegExp _gemmaThoughtBlock = RegExp(
    r'<\|(?:channel|turn)>\s*thought\b[\s\S]*?<(?:channel|turn)\|>'
    r'|<\|tool_call>[\s\S]*?<tool_call\|>',
    caseSensitive: false,
  );
  static final RegExp _gemmaThoughtTruncated = RegExp(
    r'<\|(?:channel|turn)>\s*thought\b[\s\S]*$'
    r'|<\|tool_call>[\s\S]*$',
    caseSensitive: false,
  );
  static final RegExp _internalTagBlock = RegExp(
    r'<\s*(think|thought|memory_recall|auto_memory|system_context)\b[^>]*>[\s\S]*?<\s*/\s*\1\s*>'
    r'|\[\s*(?:BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\b[^\]]*\][\s\S]*?\[\s*/\s*(?:BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\s*\]',
    caseSensitive: false,
  );
  static final RegExp _internalTagTruncated = RegExp(
    r'<\s*(think|thought|memory_recall|auto_memory|system_context)\b[^>]*>[\s\S]*$'
    r'|\[\s*(?:BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\b[^\]]*\][\s\S]*$',
    caseSensitive: false,
  );
  static final RegExp _danglingInternalTag = RegExp(
    r'<\s*/?\s*(think|thought|memory_recall|auto_memory|system_context)\b[^>]*>'
    r'|<\|/?(?:turn|channel|eot|tool_call)\|?>'
    r'|<(?:turn|channel|tool_call)\|>'
    r'|\[\s*/?\s*(?:BIOCHIP|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\b[^\]]*\]',
    caseSensitive: false,
  );
  static final RegExp _closingContentTagRe = RegExp(
    r'<\s*/\s*content\s*>',
    caseSensitive: false,
  );

  final allSkills = <ProfileSkill>[].obs;
  final profileSkills = <String, ProfileSkill>{}.obs;
  final searchQuery = ''.obs;
  final isLoading = true.obs;
  final portfolioUrl = ''.obs;

  final ProfileFirestore? _injectedProfileFirestore;
  final UserService? _injectedUserService;
  ProfileFirestore? _lazyProfileFirestore;
  bool _isClosed = false;

  SkillsController({
    ProfileFirestore? firestore,
    UserService? userService,
  }) : _injectedProfileFirestore = firestore,
       _injectedUserService = userService;

  ProfileFirestore get _profileFirestore =>
      _injectedProfileFirestore ?? (_lazyProfileFirestore ??= ProfileFirestore());

  UserService? get _resolvedUserService {
    if (_injectedUserService != null) return _injectedUserService;
    if (Sint.isRegistered<UserService>()) return Sint.find<UserService>();
    return null;
  }

  String get _profileId => _resolvedUserService?.profile.id ?? '';

  static bool isValidSkillPrice(double price) =>
      price.isFinite && price >= 0 && price <= maxSkillPrice;

  static bool _isReservedMapKey(String key) {
    final lower = key.trim().toLowerCase();
    return lower == '__proto__' ||
        lower == 'constructor' ||
        lower == 'prototype' ||
        _reservedIdRe.hasMatch(lower);
  }

  static bool isSafeProfileId(String raw) {
    if (raw.isEmpty ||
        _controlAndBidiRe.hasMatch(raw) ||
        _encodedIdTraversalRe.hasMatch(raw)) {
      return false;
    }
    final clean = raw.trim();
    if (clean != raw ||
        clean.isEmpty ||
        clean == '.' ||
        clean == '..' ||
        clean.contains('..') ||
        _reservedIdRe.hasMatch(clean)) {
      return false;
    }
    final lower = clean.toLowerCase();
    if (lower == '__proto__' ||
        lower == 'constructor' ||
        lower == 'prototype') {
      return false;
    }
    return _safeProfileIdRe.hasMatch(clean);
  }

  static String sanitizeSkillText(String raw, {int maxChars = 200}) {
    if (raw.isEmpty || !maxChars.isFinite || maxChars <= 0) return '';
    final cleaned = raw
        .replaceAll(_gemmaThoughtBlock, ' ')
        .replaceAll(_gemmaThoughtTruncated, ' ')
        .replaceAll(_internalTagBlock, ' ')
        .replaceAll(_internalTagTruncated, ' ')
        .replaceAll(_danglingInternalTag, ' ')
        .replaceAll(_closingContentTagRe, '[content_end]')
        .replaceAll(_controlAndBidiRe, '')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
    if (cleaned.length <= maxChars) return cleaned;
    var end = maxChars;
    final cu = cleaned.codeUnitAt(end - 1);
    if (cu >= 0xD800 && cu <= 0xDBFF) end -= 1;
    return end <= 0 ? '' : cleaned.substring(0, end);
  }

  /// Validates and normalizes a public portfolio URL (`https://` only, or `''`
  /// to clear). Returns `null` when [raw] uses dangerous schemes (`javascript:`,
  /// `data:`, `http:`) or targets loopback/private/IMDS SSRF endpoints.
  static String? normalizeSafePortfolioUrl(String raw) {
    if (_rawUrlUnsafeRe.hasMatch(raw)) return null;
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return '';
    if (cleaned.length > 2048) return null;
    final lowerRaw = cleaned.toLowerCase();
    if (lowerRaw.contains('%2f') ||
        lowerRaw.contains('%5c') ||
        lowerRaw.contains('%2e') ||
        lowerRaw.contains('%00') ||
        lowerRaw.contains('%25') ||
        _encodedUrlBidiRe.hasMatch(lowerRaw)) {
      return null;
    }
    final uri = Uri.tryParse(cleaned);
    if (uri == null || uri.scheme.toLowerCase() != 'https') return null;
    if (uri.userInfo.isNotEmpty) return null;
    if (uri.pathSegments.any((s) => s == '..' || s == '.')) return null;
    final host = uri.host.toLowerCase().trim();
    if (host.isEmpty ||
        !host.contains('.') ||
        host.endsWith('.') ||
        host == 'localhost' ||
        host.endsWith('.localhost') ||
        host.endsWith('.local') ||
        host.endsWith('.internal') ||
        host.endsWith('.lan') ||
        host.endsWith('.home.arpa') ||
        host.endsWith('.invalid') ||
        host.endsWith('.test') ||
        host.endsWith('.example') ||
        host.endsWith('.ts.net') ||
        host.endsWith('.onion') ||
        host == 'metadata.azure.com' ||
        host.endsWith('.metadata.azure.com') ||
        host == 'metadata.google.internal' ||
        host.endsWith('.metadata.google.internal') ||
        host == 'metadata.goog' ||
        host.endsWith('.metadata.goog') ||
        host == 'metadata' ||
        host == 'instance-data' ||
        host.contains(':')) {
      return null;
    }
    if (_canonicalIpv4Re.hasMatch(host)) {
      final parts = host.split('.').map(int.parse).toList();
      final a = parts[0];
      final b = parts[1];
      final c = parts[2];
      if (a == 0 ||
          a == 10 ||
          a == 127 ||
          (a == 100 && b >= 64 && b <= 127) ||
          (a == 169 && b == 254) ||
          (a == 172 && b >= 16 && b <= 31) ||
          (a == 192 && b == 0 && (c == 0 || c == 2)) ||
          (a == 192 && b == 168) ||
          (a == 198 && (b == 18 || b == 19)) ||
          (a == 198 && b == 51 && c == 100) ||
          (a == 203 && b == 0 && c == 113) ||
          a >= 224 ||
          parts[3] == 255) {
        return null;
      }
      return uri.toString();
    }
    if (_numericOrHexIpv4LikeRe.hasMatch(host)) return null;
    final tld = host.split('.').last;
    if (RegExp(r'^\d+$').hasMatch(tld)) return null;
    return uri.toString();
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  void onClose() {
    _isClosed = true;
    allSkills.close();
    profileSkills.close();
    searchQuery.close();
    isLoading.close();
    portfolioUrl.close();
    super.onClose();
  }

  Future<void> _loadData() async {
    if (_isClosed) return;
    isLoading.value = true;
    try {
      await _loadSkillsFromAsset();
      if (_isClosed) return;
      final userSvc = _resolvedUserService;
      final current = userSvc?.profile.skills;
      if (current != null && current.isNotEmpty) {
        profileSkills.value = Map<String, ProfileSkill>.from(current);
      }
      portfolioUrl.value = userSvc?.profile.portfolioUrl ?? '';
    } catch (e) {
      AppConfig.logger.e('Error loading skills: $e');
    } finally {
      if (!_isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> _loadSkillsFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString(DataAssets.userSkillsJsonPath);
      if (_isClosed) return;
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        allSkills.value = decoded
            .whereType<Map>()
            .map((e) => ProfileSkill.fromJsonDefault(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      AppConfig.logger.e('Error loading freelance expertise JSON: $e');
    }
  }

  List<ProfileSkill> get filteredSkills {
    final query =
        sanitizeSkillText(searchQuery.value, maxChars: 120).toLowerCase();
    if (query.isEmpty) return allSkills;
    return allSkills.where((s) =>
      s.name.toLowerCase().contains(query) ||
      s.description.toLowerCase().contains(query)
    ).toList();
  }

  bool isSkillAdded(String skillName) => profileSkills.containsKey(skillName);

  bool get canAddMore => profileSkills.length < maxSkills;

  Future<bool> addSkill(ProfileSkill skill, ExperienceLevel level, {double price = 0}) async {
    if (_isClosed || !canAddMore || !isValidSkillPrice(price)) return false;
    final safeName = sanitizeSkillText(skill.name, maxChars: 120);
    if (safeName.isEmpty ||
        _isReservedMapKey(safeName) ||
        isSkillAdded(safeName)) {
      return false;
    }

    final newSkill = ProfileSkill(
      id: safeName,
      name: safeName,
      description: sanitizeSkillText(skill.description, maxChars: 500),
      experienceLevel: level,
      price: price,
    );

    profileSkills[safeName] = newSkill;
    _resolvedUserService?.profile.skills =
        Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> removeSkill(String skillName) async {
    if (_isClosed) return false;
    final safeName = sanitizeSkillText(skillName, maxChars: 120);
    if (safeName.isEmpty) return false;
    profileSkills.remove(safeName);
    _resolvedUserService?.profile.skills =
        Map<String, ProfileSkill>.from(profileSkills);
    return _persistSkills();
  }

  Future<bool> updateSkillLevel(String skillName, ExperienceLevel level) async {
    if (_isClosed) return false;
    final skill = profileSkills[skillName];
    if (skill == null) return false;

    skill.experienceLevel = level;
    profileSkills[skillName] = skill;
    profileSkills.refresh();
    _resolvedUserService?.profile.skills =
        Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> updateSkillPrice(String skillName, double price) async {
    if (_isClosed || !isValidSkillPrice(price)) return false;
    final skill = profileSkills[skillName];
    if (skill == null) return false;

    skill.price = price;
    profileSkills[skillName] = skill;
    profileSkills.refresh();
    _resolvedUserService?.profile.skills =
        Map<String, ProfileSkill>.from(profileSkills);

    return _persistSkills();
  }

  Future<bool> savePortfolioUrl(String url) async {
    if (_isClosed) return false;
    final normalized = normalizeSafePortfolioUrl(url);
    if (normalized == null) return false;
    final pid = _profileId;
    if (!isSafeProfileId(pid)) {
      return false;
    }
    portfolioUrl.value = normalized;
    _resolvedUserService?.profile.portfolioUrl = normalized;
    return _profileFirestore.updatePortfolioUrl(pid, normalized);
  }

  Future<bool> _persistSkills() async {
    final pid = _profileId;
    if (!isSafeProfileId(pid)) {
      return false;
    }
    final skillsMap =
        profileSkills.map((key, value) => MapEntry(key, value.toJSON()));
    return _profileFirestore.updateSkills(pid, skillsMap);
  }
}
