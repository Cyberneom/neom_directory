import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/data/firestore/profile_firestore.dart';
import 'package:neom_core/data/implementations/user_controller.dart';
import 'package:neom_core/domain/model/app_profile.dart';
import 'package:neom_core/domain/repository/account_repository.dart';
import 'package:neom_core/utils/constants/app_hive_constants.dart';
import 'package:neom_core/utils/enums/app_hive_box.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_core/utils/enums/profile_type.dart';
import 'package:neom_core/utils/enums/usage_reason.dart';
import 'package:neom_core/utils/profile_directory_policy.dart';
import 'package:neom_directory/ui/directory_controller.dart';
import 'package:neom_directory/ui/widgets/directory_profile_card.dart';
import 'package:neom_directory/utils/constants/directory_translation_constants.dart';
import 'package:sint/sint.dart';

class _NoFirestore extends Fake implements FirebaseFirestore {}

class _NoAccounts extends Fake implements AccountRepository {}

// Keep ProfileFirestore.getWithParameters real: its public needsPhone gate
// was what silently discarded the directory's public projections.
class _PublicProfiles extends ProfileFirestore {
  _PublicProfiles(this.batches) : super(firestore: _NoFirestore());

  final List<List<AppProfile>> batches;
  final limits = <int>[];

  @override
  Future<Map<String, AppProfile>> retrieveAllProfiles({
    int limit = 0,
    bool forceRefresh = false,
  }) async {
    limits.add(limit);
    final batch = batches.removeAt(0);
    return {for (final profile in batch) profile.id: profile};
  }
}

class _Directory extends DirectoryController {
  _Directory(ProfileFirestore profiles) : super(profileFirestore: profiles);

  // Supply the visitor location explicitly; these tests never request it
  // from the OS. The inherited initialization still attaches pagination.
  @override
  void onReady() {}

  void loadFromCache() => super.onReady();
}

AppProfile projected(String id, String name, {bool showPhone = false}) =>
    ProfileDirectoryPolicy.publicProjection(
      AppProfile(
        id: id,
        name: name,
        type: ProfileType.host,
        usageReason: UsageReason.professional,
        phoneNumber: 'fixture-phone',
        showPhone: showPhone,
      ),
    );

Position positionAt(double latitude) => Position(
  latitude: latitude,
  longitude: -103.3,
  timestamp: DateTime(2026),
  accuracy: 1,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temporaryDirectory;
  late Box directoryBox;
  late AppInUse previousApp;
  _Directory? controller;

  setUp(() async {
    previousApp = AppConfig.instance.appInUse;
    AppConfig.instance.appInUse = AppInUse.g;
    Sint.reset();
    Sint.put<UserController>(UserController(userFirestore: _NoAccounts()));
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'neom-directory-public-',
    );
    Hive.init(temporaryDirectory.path);
    directoryBox = await Hive.openBox(AppHiveBox.directory.name);
  });

  tearDown(() async {
    if (controller != null && !controller!.isClosed) {
      controller!.onClose();
    }
    controller = null;
    Sint.reset();
    await Hive.close();
    await temporaryDirectory.delete(recursive: true);
    AppConfig.instance.appInUse = previousApp;
  });

  test(
    'public profiles without phone or location load by name, preserving namesakes',
    () async {
      final profiles = _PublicProfiles([
        [
          projected('zulu', 'Zulu'),
          projected('same-b', 'Same'),
          projected('alpha', 'Alpha', showPhone: true),
          projected('same-a', 'Same'),
        ],
      ]);
      final directory = controller = _Directory(profiles);

      await directory.getDirectoryProfiles();

      expect(directory.position, isNull);
      expect(directory.directoryProfiles.values.map((p) => p.id), [
        'alpha',
        'same-a',
        'same-b',
        'zulu',
      ]);
      expect(directory.hasDirectoryDistances, isFalse);
      final byId = {
        for (final p in directory.directoryProfiles.values) p.id: p,
      };
      expect(byId['same-a']!.phoneNumber, isEmpty);
      expect(byId['same-b']!.phoneNumber, isEmpty);
      expect(byId['alpha']!.phoneNumber, 'fixture-phone');
      expect(profiles.limits, [200]);
      final cached =
          directoryBox.get(AppHiveConstants.directoryProfiles) as Map;
      expect(cached, hasLength(4));
    },
  );

  testWidgets(
    'pagination without projected locations retains namesakes and avoids duplicate IDs',
    (tester) async {
      final profiles = _PublicProfiles([
        [
          projected('beta', 'Beta'),
          projected('same-b', 'Same'),
          projected('same-a', 'Same'),
        ],
        [projected('alpha', 'Alpha'), projected('beta', 'Beta')],
      ]);
      final directory = controller = _Directory(profiles);
      await tester.pumpWidget(
        SintMaterialApp(
          initialRoute: '/directory-fixture',
          sintPages: [
            SintPage(
              name: '/directory-fixture',
              page: () => Scaffold(
                body: SingleChildScrollView(
                  controller: directory.directoryScrollController,
                  child: const SizedBox(height: 2000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      directory.onInit();
      directory.position = positionAt(20.6);
      await tester.runAsync(directory.getDirectoryProfiles);
      expect(directory.directoryProfiles, hasLength(3));
      expect(directory.hasDirectoryDistances, isFalse);

      directory.directoryScrollController.jumpTo(
        directory.directoryScrollController.position.maxScrollExtent,
      );
      await tester.pump();

      expect(profiles.limits, [200, 10]);
      expect(directory.isLoadingNextDirectory, isFalse);
      expect(directory.directoryProfiles.values.map((p) => p.id), [
        'alpha',
        'beta',
        'same-a',
        'same-b',
      ]);
      expect(directory.hasDirectoryDistances, isFalse);
      expect(
        directory.directoryProfiles.values.map((p) => p.phoneNumber),
        everyElement(isEmpty),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'cached name-order indices are recomputed before showing distances',
    (tester) async {
      AppConfig.instance.appInUse = AppInUse.c;
      final profiles = _PublicProfiles([]);
      final directory = controller = _Directory(profiles);
      final far = AppProfile(
        id: 'far',
        name: 'Alpha',
        position: positionAt(21.6),
      );
      final near = AppProfile(
        id: 'near',
        name: 'Zulu',
        position: positionAt(20.601),
      );
      await tester.runAsync(() => directoryBox.put(
        AppHiveConstants.directoryProfiles,
        {0.0: far.toJSONWithFacilities(), 1.0: near.toJSONWithFacilities()},
      ));
      directory.profile = AppProfile(position: positionAt(20.6));
      directory.appHiveController.directoryLastUpdate = directory.today;

      await tester.runAsync(() async {
        directory.loadFromCache();
        await Future<void>.delayed(Duration.zero);
      });

      expect(directory.isLoading.value, isFalse);
      expect(directory.directoryProfiles.values.map((p) => p.id), [
        'near',
        'far',
      ]);
      expect(directory.filteredProfiles.values.map((p) => p.id), [
        'near',
        'far',
      ]);
      expect(directory.directoryProfiles.keys.first, lessThan(2));
      expect(directory.directoryProfiles.keys.last, greaterThan(100));
      expect(directory.hasDirectoryDistances, isTrue);
      expect(profiles.limits, isEmpty);
    },
  );

  testWidgets(
    'public card tolerates redacted facilities and follows target contact opt-in',
    (tester) async {
      final profiles = _PublicProfiles([]);
      final directory = controller = _Directory(profiles);
      directory.userController.profile.showPhone = false;
      var target = projected('no-phone', 'Hidden');
      late StateSetter rebuild;
      await tester.pumpWidget(
        SintMaterialApp(
          initialRoute: '/card-fixture',
          sintPages: [
            SintPage(
              name: '/card-fixture',
              page: () {
                if (!Sint.isRegistered<DirectoryController>()) {
                  Sint.put<DirectoryController>(directory);
                }
                return StatefulBuilder(
                  builder: (context, setState) {
                    rebuild = setState;
                    return Scaffold(body: DirectoryProfileCard(target));
                  },
                );
              },
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Hidden'), findsOneWidget);
      expect(find.text(DirectoryTranslationConstants.toContact), findsNothing);
      expect(find.textContaining(' KM'), findsNothing);

      rebuild(() => target = projected('opt-in', 'Opt-in', showPhone: true));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        find.text(DirectoryTranslationConstants.toContact),
        findsOneWidget,
      );

      rebuild(
        () => target = AppProfile(
          id: 'opt-out',
          name: 'Opt-out',
          phoneNumber: 'fixture-phone',
          showPhone: false,
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text(DirectoryTranslationConstants.toContact), findsNothing);
      expect(profiles.limits, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
