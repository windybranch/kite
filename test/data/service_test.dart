import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/data/article.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/service_local.dart';
import 'package:kite/data/service_remote.dart';
import 'package:mocktail/mocktail.dart' as mock;
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

import '../../testing/articles.dart';
import '../../testing/categories.dart';
import '../../testing/service.dart';

void main() {
  group('test fetching local categories json', () {
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

        then('it should return a failure', () {
          final err = result.exceptionOrNull();
          err.should.not.beNull();
        });
      });
    });
  });

  group('test fetching local articles json', () {
    given('a local asset json file', () {
      late FakeLoader loader;

      when('fetching articles json for a category', () {
        loader = FakeLoader(kArticleJson);
        final service = LocalService(loader);
        late Result<List<ArticleModel>> result;

        before(() async {
          final category = CategoryModel(name: 'World', file: 'world.json');
          result = await service.fetchArticles(category);
          result.isSuccess().should.beTrue();
        });

        then('it should return a list of article models', () {
          final models = result.getOrNull();
          models.should.not.beNull();
          models?.length.should.be(kArticleModels.length);
          final match = listEquals(models, kArticleModels);
          match.should.beTrue();
        });
      });

      when('fetching articles fails', () {
        loader = FakeLoader(kArticleJson, fail: true);
        final service = LocalService(loader);
        late Result<List<ArticleModel>> result;

        before(() async {
          final category = CategoryModel(name: 'World', file: 'world.json');
          result = await service.fetchArticles(category);
          result.isError().should.beTrue();
        });

        then('it should return a failure', () {
          final err = result.exceptionOrNull();
          err.should.not.beNull();
        });
      });
    });
  });

  group('test fetching remote categories json', () {
    setUpAll(() => mock.registerFallbackValue(FakeUri()));

    given('a remote json url', () {
      final client = MockHttpClient();
      final response = MockHttpResponse();

      before(() async {
        mock.when(() => response.statusCode).thenReturn(HttpStatus.ok);
        mock.when(() => response.body).thenReturn(kCategoriesJson);
        mock
            .when(() => client.get(mock.any()))
            .thenAnswer((_) async => response);
      });

      when('fetching the categories from the url', () {
        final service = RemoteService(client);
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

      when('the request fails', () {
        final service = RemoteService(client);
        late Result<List<CategoryModel>> result;

        before(() async {
          mock
              .when(() => response.statusCode)
              .thenReturn(HttpStatus.serverError);
          mock.when(() => response.body).thenReturn('Internal Server Error');

          result = await service.fetchCategories();
          result.isError().should.beTrue();
        });

        then('it should return a failure', () {
          final err = result.exceptionOrNull();
          err.should.not.beNull();
        });
      });
    });

    group('test fetching remote articles json', () {
      setUpAll(() => mock.registerFallbackValue(FakeUri()));

      given('a remote json url', () {
        final client = MockHttpClient();
        final response = MockHttpResponse();

        before(() async {
          mock.when(() => response.statusCode).thenReturn(HttpStatus.ok);
          mock.when(() => response.body).thenReturn(kArticleJson);
          mock
              .when(() => client.get(mock.any()))
              .thenAnswer((_) async => response);
        });

        when('fetching articles json for a category', () {
          final service = RemoteService(client);
          late Result<List<ArticleModel>> result;

          before(() async {
            final category = CategoryModel(name: 'World', file: 'world.json');
            result = await service.fetchArticles(category);
            result.isSuccess().should.beTrue();
          });

          then('it should return a list of article models', () {
            final models = result.getOrNull();
            models.should.not.beNull();
            models?.length.should.be(kArticleModels.length);
            final match = listEquals(models, kArticleModels);
            match.should.beTrue();
          });
        });
      });
    });
  });
}
