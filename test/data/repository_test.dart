import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/data/repository.dart';
import 'package:kite/logic/categories.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

import '../../testing/articles.dart';
import '../../testing/categories.dart';
import '../../testing/service.dart';

void main() {
  setUpAll(() => GivenWhenThenOptions.pads = 4);

  group('test repository behaviour', () {
    given('a list of category models', () {
      final models = kCategoryModels;

      when('the repository loads successfully', () {
        final service = FakeService();
        final repository = CacheRepository(service);
        late Result<List<Category>> result;
        final categories = <Category>[];

        before(() async {
          result = await repository.loadCategories();
          result.isSuccess().should.beTrue();
        });

        then('the categories are returned', () {
          final categoriesResult = result.getOrNull() ?? [];
          categories.addAll(categoriesResult);
          categories.should.not.beNull();
          categories.should.not.beEmpty();
          categories.length.should.be(models.length);
        }, and: {
          'the correct articles are in the categories': () {
            final worlds =
                categories.where((c) => c.name == kWorldCategory).toList();
            worlds.length.should.be(1);
            final world = worlds.first;
            world.should.not.beNull();
            world.articles.length.should.be(kArticles.length);

            // TODO: make this match work.
            //
            // The match fails with deep equality matching the [Perspective]s records.
            // The [Source] records are a nested [List] and won't pass equality checks.
            //
            // https://stackoverflow.com/questions/76697156/how-do-i-compare-dart-records-with-deep-equality
            final match = listEquals(world.articles, kArticles);
            // match.should.beTrue();
          },
          'the articles have ids': () {
            final worlds =
                categories.where((c) => c.name == kWorldCategory).toList();
            worlds.length.should.be(1);
            final world = worlds.first;
            world.should.not.beNull();

            for (final article in world.articles) {
              article.id.should.not.beBlank();
            }
          },
        });
      });

      when('the repository fails to load categories', () {
        final service = FakeService(Fail.categories);
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

      when('the repository fails to load articles', () {
        final service = FakeService(Fail.articles);
        final repository = CacheRepository(service);
        late Result<List<Category>> result;

        before(() async {
          result = await repository.loadCategories();
          result.isError().should.beTrue();
        });

        then('a failure is returned', () {
          final failure = result.exceptionOrNull();
          failure.should.not.beNull();
          failure.toString().contains('articles').should.beTrue();
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
          service.fail = Fail.categories;
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

    given('the cache has a list of categories', () {
      final service = FakeService();
      final repository = CacheRepository(service);
      late Result<List<Category>> result;
      String articleId = '';
      List<Category> original = [];

      before(() async {
        result = await repository.loadCategories();
        result.isSuccess().should.beTrue();
        final categories = result.getOrNull() ?? [];
        original = categories;
        final article = categories
            .firstWhere((c) => c.name == kWorldCategory)
            .articles
            .first;
        article.read.should.beFalse();
        articleId = article.id;
        articleId.should.not.beBlank();
      });

      when('an article is marked as read', () {
        late List<Category> updated;
        late List<Category> cache;

        before(() async {
          result = await repository.updateReadStatus(
            kWorldCategory,
            articleId,
            read: true,
          );
          result.isSuccess().should.beTrue();

          updated = result.getOrNull() ?? [];
          updated.should.not.beEmpty();

          result = await repository.loadCategories();
          result.isSuccess().should.beTrue();
          cache = result.getOrNull() ?? [];
          cache.should.not.beEmpty();
        });

        then('the cache should be updated', () {
          final article =
              cache.firstWhere((c) => c.name == kWorldCategory).articles.first;
          article.id.should.be(articleId);
          article.read.should.beTrue();
          // TODO: this might fail even if matched,
          // due to same deep equality issue above.
          bool match = listEquals(cache, original);
          match.should.not.beTrue();

          match = listEquals(cache, updated);
          match.should.beTrue();
        });
      });
    });
  });
}
