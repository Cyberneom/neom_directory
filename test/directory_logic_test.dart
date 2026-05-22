import 'package:flutter_test/flutter_test.dart';
import 'package:neom_core/domain/model/app_profile.dart';
import 'package:neom_core/utils/enums/profile_type.dart';

/// These tests cover the pure logic the DirectoryController relies on.
/// They avoid Sint/Firestore so they can run without mocks.

// Replicates DirectoryController.getAllFilterableProfileTypes (pure list filter).
List<ProfileType> filterableProfileTypes() {
  return ProfileType.values
      .where((t) =>
          t != ProfileType.general &&
          t != ProfileType.researcher &&
          t != ProfileType.broadcaster)
      .toList();
}

// Replicates DirectoryController.filterByQuery's pure expression.
Map<double, AppProfile> filterByQuery(
    Map<double, AppProfile> source, String query) {
  if (query.trim().isEmpty) return Map.of(source);
  final q = query.toLowerCase();
  final out = <double, AppProfile>{};
  for (final entry in source.entries) {
    final p = entry.value;
    final hasSkillMatch = p.skills?.values.any(
            (s) => s.name.toLowerCase().contains(q)) ??
        false;
    if (p.name.toLowerCase().contains(q) ||
        p.aboutMe.toLowerCase().contains(q) ||
        p.mainFeature.toLowerCase().contains(q) ||
        p.address.toLowerCase().contains(q) ||
        hasSkillMatch) {
      out[entry.key] = p;
    }
  }
  return out;
}

// Replicates the category filter logic.
Map<double, AppProfile> applyTypeFilter(
    Map<double, AppProfile> source, Set<ProfileType> selected) {
  if (selected.isEmpty) return Map.of(source);
  final out = <double, AppProfile>{};
  for (final entry in source.entries) {
    if (selected.contains(entry.value.type)) {
      out[entry.key] = entry.value;
    }
  }
  return out;
}

void main() {
  group('filterableProfileTypes', () {
    test('excludes general/researcher/broadcaster', () {
      final types = filterableProfileTypes();
      expect(types.contains(ProfileType.general), isFalse);
      expect(types.contains(ProfileType.researcher), isFalse);
      expect(types.contains(ProfileType.broadcaster), isFalse);
    });

    test('includes appArtist/facilitator/host/collective', () {
      final types = filterableProfileTypes();
      expect(types, containsAll([
        ProfileType.appArtist,
        ProfileType.facilitator,
        ProfileType.host,
        ProfileType.collective,
      ]));
    });
  });

  group('filterByQuery edge cases', () {
    final profiles = <double, AppProfile>{
      1.0: AppProfile(name: 'Alice Rock', aboutMe: 'guitarist'),
      2.0: AppProfile(name: 'Bob Jazz', aboutMe: 'drummer', address: 'NYC'),
      3.0: AppProfile(name: '', aboutMe: '', mainFeature: 'producer'),
    };

    test('empty query returns all', () {
      expect(filterByQuery(profiles, '').length, 3);
      expect(filterByQuery(profiles, '   ').length, 3);
    });

    test('case-insensitive match on name', () {
      final result = filterByQuery(profiles, 'ALICE');
      expect(result.values.first.name, 'Alice Rock');
    });

    test('match on aboutMe', () {
      final result = filterByQuery(profiles, 'drum');
      expect(result.length, 1);
      expect(result.values.first.name, 'Bob Jazz');
    });

    test('match on mainFeature works for empty-name profile', () {
      final result = filterByQuery(profiles, 'producer');
      expect(result.length, 1);
    });

    test('match on address', () {
      final result = filterByQuery(profiles, 'nyc');
      expect(result.length, 1);
    });

    test('no match returns empty', () {
      expect(filterByQuery(profiles, 'xyzqwerty'), isEmpty);
    });

    test('empty source returns empty even for non-empty query', () {
      expect(filterByQuery(<double, AppProfile>{}, 'foo'), isEmpty);
    });
  });

  group('applyTypeFilter', () {
    final profiles = <double, AppProfile>{
      1.0: AppProfile(name: 'A', type: ProfileType.appArtist),
      2.0: AppProfile(name: 'B', type: ProfileType.host),
      3.0: AppProfile(name: 'C', type: ProfileType.facilitator),
    };

    test('empty filter set returns all profiles', () {
      expect(applyTypeFilter(profiles, {}).length, 3);
    });

    test('single type filter narrows down', () {
      final out = applyTypeFilter(profiles, {ProfileType.host});
      expect(out.length, 1);
      expect(out.values.first.name, 'B');
    });

    test('multiple type filters union', () {
      final out = applyTypeFilter(profiles, {
        ProfileType.host,
        ProfileType.appArtist,
      });
      expect(out.length, 2);
    });

    test('filter type with no matches returns empty', () {
      final out = applyTypeFilter(profiles, {ProfileType.broadcaster});
      expect(out, isEmpty);
    });

    test('keys are preserved (geo-distance keys)', () {
      final out = applyTypeFilter(profiles, {ProfileType.host});
      expect(out.keys.first, 2.0);
    });
  });

  group('AppProfile.generateSlug', () {
    test('lowercases and removes whitespace', () {
      expect(AppProfile.generateSlug('Serzen Montoya'), 'serzenmontoya');
    });

    test('strips punctuation but keeps spanish accents', () {
      expect(AppProfile.generateSlug('José-Pérez!'), 'josépérez');
    });

    test('empty string returns empty', () {
      expect(AppProfile.generateSlug(''), '');
    });

    test('only spaces returns empty', () {
      expect(AppProfile.generateSlug('     '), '');
    });

    test('digits are preserved', () {
      expect(AppProfile.generateSlug('Collective 23'), 'collective23');
    });
  });
}
