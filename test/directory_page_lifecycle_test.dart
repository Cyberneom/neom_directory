import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_core/data/firestore/profile_firestore.dart';
import 'package:neom_core/data/implementations/user_controller.dart';
import 'package:neom_core/domain/repository/account_repository.dart';
import 'package:neom_directory/ui/directory_controller.dart';
import 'package:neom_directory/ui/directory_page.dart';
import 'package:neom_directory/utils/constants/directory_translation_constants.dart';
import 'package:sint/sint.dart';

class _NoFirestore extends Fake implements FirebaseFirestore {}

class _NoAccounts extends Fake implements AccountRepository {}

class _TestAssets extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    if (key == 'assets/appIcon_white.png') {
      return Future.value(
        ByteData.sublistView(
          base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
          ),
        ),
      );
    }
    return rootBundle.load(key);
  }
}

class _LoadingDirectory extends DirectoryController {
  _LoadingDirectory()
    : super(profileFirestore: ProfileFirestore(firestore: _NoFirestore()));

  final loaded = Completer<void>();
  var starts = 0;
  var closes = 0;

  @override
  void onInit() {
    super.onInit();
    starts++;
  }

  @override
  void onReady() async {
    await loaded.future;
    isLoading.value = false;
    update();
  }

  @override
  void onClose() {
    closes++;
    super.onClose();
  }
}

void main() {
  testWidgets(
    'resize while loading preserves the mounted directory and route exit disposes it',
    (tester) async {
      Sint.reset();
      Sint.put<UserController>(UserController(userFirestore: _NoAccounts()));
      final directory = _LoadingDirectory();
      late StateSetter rebuild;
      var width = 1440.0;
      var showDirectory = true;
      addTearDown(() {
        directory.directoryScrollController.dispose();
        Sint.reset();
      });
      await tester.pumpWidget(
        SintMaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return DefaultAssetBundle(
                bundle: _TestAssets(),
                child: MediaQuery(
                  data: MediaQueryData(size: Size(width, 844)),
                  child: showDirectory
                      ? DirectoryPage(controller: directory)
                      : const Scaffold(body: Text('Home fixture')),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(Sint.find<DirectoryController>(), same(directory));
      expect(directory.starts, 1);
      expect(directory.isLoading.value, isTrue);

      rebuild(() => width = 390);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        directory.closes,
        0,
        reason: 'A viewport change is not a route exit',
      );
      expect(Sint.find<DirectoryController>(), same(directory));

      directory.loaded.complete();
      await tester.pumpAndSettle(
        const Duration(milliseconds: 50),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 2),
      );
      expect(tester.takeException(), isNull);
      expect(directory.isLoading.value, isFalse);
      expect(
        find.text(DirectoryTranslationConstants.noNearResultsWereFound.tr),
        findsOneWidget,
      );
      expect(directory.starts, 1);

      rebuild(() => showDirectory = false);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('Home fixture'), findsOneWidget);
      expect(directory.closes, 1);
      expect(Sint.isRegistered<DirectoryController>(), isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
