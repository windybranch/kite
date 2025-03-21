import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/data/repository.dart';
import 'package:kite/data/service.dart';
import 'package:kite/data/service_local.dart';
import 'package:kite/logic/home.dart';
import 'package:kite/logic/repository.dart';
import 'package:kite/ui/home_screen.dart';

import '../../testing/app.dart';
import '../../testing/categories.dart';

void main() {
  group('test home screen view', () {
    late HomeViewModel model;
    late Repository repo;
    late Service service;

    setUp(() {
      service = LocalService(LocalAssetLoader());
      repo = CacheRepository(service);
      model = HomeViewModel(repo: repo);
    });

    testWidgets('displays categories', (tester) async {
      await tester.runAsync(() async {
        await testApp(tester, HomeScreen(model: model));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // TODO: fix this test
        //
        // [pumpAndSettle] times out here and does not
        // move past the initial loading state with the
        // CircularProgressIndicator.
        //
        // Relevant issue: https://github.com/flutter/flutter/issues/64564
        // await tester.pumpAndSettle();
      });

      final cat1 = kCategories[0].name;
      final cat2 = kCategories[1].name;
      final cat1Finder = find.text(cat1);
      final cat2Finder = find.text(cat2);

      // expect(cat1Finder, findsOneWidget);
      // expect(cat2Finder, findsOneWidget);
    });
  });
}
