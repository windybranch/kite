import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/service_local.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

const String _kJson = '''
{
  "timestamp": 1741958498,
  "categories": [
    {
      "name": "World",
      "file": "world.json"
    },
    {
      "name": "USA",
      "file": "usa.json"
    },
    {
      "name": "Business",
      "file": "business.json"
    },
    {
      "name": "Technology",
      "file": "tech.json"
    }
  ]
}
''';

const _kModels = [
  CategoryModel('World', 'world.json'),
  CategoryModel('USA', 'usa.json'),
  CategoryModel('Business', 'business.json'),
  CategoryModel('Technology', 'tech.json')
];

class FakeLoader implements AssetLoader {
  FakeLoader({this.fail = false});

  bool fail;

  @override
  AsyncResult<String> loadAsset(String path) {
    return fail
        ? Future.value(Failure(Exception('failed to load asset')))
        : Future.value(Success(_kJson));
  }
}

void main() {
  group('test fetching categories json', () {
    given('a local asset json file', () {
      late FakeLoader loader;

      when('fetching categories json', () {
        loader = FakeLoader();
        final service = LocalService(loader);
        late Result<List<CategoryModel>> result;

        before(() async {
          result = await service.fetchCategories();
          result.isSuccess().should.beTrue();
        });

        then('it should return a list of category models', () {
          final models = result.getOrNull();
          models.should.not.beNull();
          models?.length.should.be(_kModels.length);
          final match = listEquals(models, _kModels);
          match.should.beTrue();
        });
      });

      when('fetching categories fails', () {
        loader = FakeLoader(fail: true);
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
}
