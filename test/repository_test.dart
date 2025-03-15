import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/repository.dart';
import 'package:kite/data/service.dart';
import 'package:kite/logic/categories.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

const _kCategories = [
  CategoryModel('Technology', 'tech.json'),
  CategoryModel('Science', 'science.json'),
  CategoryModel('Sports', 'sports.json'),
];

class FakeService implements Service {
  bool fail;

  FakeService({this.fail = false});

  @override
  AsyncResult<List<CategoryModel>> fetchCategories() {
    return fail
        ? Future.value(Failure(Exception('failed to fetch categories')))
        : Future.value(Success(_kCategories));
  }
}

void main() {
  group('test repository behaviour', () {
    given('a list of category models', () {
      final models = _kCategories;

      when('the repository loads successfully', () {
        final service = FakeService();
        final repository = CacheRepository(service);
        late Result<List<Category>> result;

        before(() async {
          result = await repository.loadCategories();
          result.isSuccess().should.beTrue();
        });

        then('the categories are returned', () {
          final categories = result.getOrNull();
          categories.should.not.beNull();
          categories.should.not.beEmpty();

          bool match = false;

          for (final model in models) {
            if (model.name == categories?.first.name) {
              match = true;
              break;
            }
          }

          match.should.beTrue();
        });
      });

      when('the repository fails to load', () {
        final service = FakeService(fail: true);
        final repository = CacheRepository(service);
        late Result<List<Category>> result;

        before(() async {
          result = await repository.loadCategories();
          result.isError().should.beTrue();
        });

        then('a failure is returned', () {
          final failure = result.exceptionOrNull();
          failure.should.not.beNull();
        });
      });

      when('the repository has cached categories', () {
        final service = FakeService();
        final repository = CacheRepository(service);
        final fetched = <Category>[];
        final cached = <Category>[];

        before(() async {
          Result<List<Category>> result = await repository.loadCategories();
          result.isSuccess().should.beTrue();

          final categories = result.getOrNull();
          categories.should.not.beNull();
          categories.should.not.beEmpty();
          fetched.addAll(categories!);

          // Verify the cache by forcing the service to error.
          service.fail = true;
          result = await repository.loadCategories();
          result.isSuccess().should.beTrue();
          final cachedCategories = result.getOrNull();
          cached.addAll(cachedCategories!);
        });

        then('it uses the cache', () {
          cached.should.not.beEmpty();
          final match = listEquals(cached, fetched);
          match.should.beTrue();
        });
      });
    });
  });
}
