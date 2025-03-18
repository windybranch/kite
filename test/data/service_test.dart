import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/service_local.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

import '../../testing/categories.dart';
import '../../testing/service.dart';

void main() {
  group('test fetching categories json', () {
    given('a local asset json file', () {
      late FakeLoader loader;

      when('fetching categories json', () {
        loader = FakeLoader(kCategoriesJson);
        final service = LocalService(loader);
        late Result<List<CategoryModel>> result;

        before(() async {
          result = await service.fetchCategories();
          result.isSuccess().should.beTrue();
        });

        then('it should return a list of category models', () {
          final models = result.getOrNull();
          models.should.not.beNull();
          models?.length.should.be(kCategoryModels.length);
          final match = listEquals(models, kCategoryModels);
          match.should.beTrue();
        });
      });

      when('fetching categories fails', () {
        loader = FakeLoader(kCategoriesJson, fail: true);
        final service = LocalService(loader);
        late Result<List<CategoryModel>> result;

        before(() async {
          result = await service.fetchCategories();
          result.isError().should.beTrue();
        });

        after(() => loader.fail = false);

        then('it should return a failure', () {
          final err = result.exceptionOrNull();
          err.should.not.beNull();
        });
      });
    });
  });

  group('test fetching articles json', () {
    given('a local asset json file', () {
      when('fetching articles json for a category', () {
        then('it should return a list of article models', () {
          //
        });
      });
    });
  });
}
