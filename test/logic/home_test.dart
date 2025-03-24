import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/logic/article.dart';
import 'package:kite/logic/categories.dart';
import 'package:kite/logic/home.dart';
import 'package:kite/logic/repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

import '../../testing/articles.dart';

const _kCategories = [
  Category('Technology', []),
  Category('Science', []),
  Category('Sports', []),
];

class FakeRepository implements Repository {
  FakeRepository({this.success, this.fail = false})
      : cache = [...(success ?? _kCategories)];

  bool fail;
  final List<Category>? success;
  final List<Category> cache;

  @override
  AsyncResult<List<Category>> loadCategories() {
    return fail
        ? Future.value(Failure(Exception('Failed')))
        : Future.value(Success(cache));
  }

  @override
  AsyncResult<List<Category>> updateReadStatus(
    String categoryName,
    String articleId, {
    required bool read,
  }) {
    if (fail) return Future.value(Failure(Exception('Failed')));

    for (final category in cache) {
      if (category.name == categoryName) {
        final articles = category.articles;
        final article = articles.firstWhere((a) => a.id == articleId);
        final marked = article.copyMarked(read: true);
        final updatedArticles = articles.map((a) {
          if (a.id == articleId) return marked;
          return a;
        }).toList();

        final updatedCategory = Category(
          category.name,
          updatedArticles,
        );

        final updatedCache = cache.map((c) {
          if (c.name == categoryName) return updatedCategory;
          return c;
        }).toList();

        if (updatedCache.isNotEmpty) {
          cache.clear();
          cache.addAll(updatedCache);
        }

        return Future.value(Success(cache));
      }
    }

    throw UnimplementedError();
  }
}

void main() {
  group('test home logic', () {
    given('a list of categories', () {
      const categories = _kCategories;

      when('loading', () {
        final repo = FakeRepository();
        final model = HomeViewModel(repo: repo);

        before(() async {
          await model.load.execute();
          model.load.isSuccess.should.beTrue();
        });

        then('the categories are returned', () {
          model.categories.should.be(categories);
        });
      });

      when('loading fails', () {
        final repo = FakeRepository(fail: true);
        final model = HomeViewModel(repo: repo);

        before(() async {
          await model.load.execute();
          model.load.isFailure.should.beTrue();
        });

        then('the categories are empty', () {
          model.categories.should.beEmpty();
        });
      });
    });

    given('the categories fail to load first time', () {
      const categories = _kCategories;
      final repo = FakeRepository(fail: true);
      final model = HomeViewModel(repo: repo);

      before(() async {
        await model.load.execute();
        model.load.isFailure.should.beTrue();
      });

      when('retrying', () {
        before(() async {
          repo.fail = false;
          await model.retry();
          model.load.isSuccess.should.beTrue();
        });

        then('the categories are loaded', () {
          model.categories.should.be(categories);
        });
      });
    });

    given('a list of categories', () {
      final article = Article(
        id: 'id',
        group: 'Technology',
        title: 'title',
        summary: 'summary',
        highlights: [],
        quote: (author: '', content: '', domain: '', url: ''),
        perspectives: [],
        background: '',
        reactions: [],
        timeline: [],
        sources: [],
        fact: '',
      );
      final category = Category('World', [article, ...kArticles]);
      final categories = [
        category,
        ..._kCategories,
      ];

      final repo = FakeRepository(success: categories);
      var model = HomeViewModel(repo: repo);

      before(() async {
        await model.load.execute();
        model.load.isSuccess.should.beTrue();
      });

      when('an article is read', () {
        before(() async {
          await model.markArticle(category.name, article.id, read: true);
        });

        then('the categories should be updated', () {
          final match = listEquals(categories, model.categories);
          match.should.not.beTrue();
        }, and: {
          'the article is marked as read': () {
            final updated = model.categories;
            for (final cat in updated) {
              if (cat.name == category.name) {
                cat.articles
                    .firstWhere((a) => a.id == article.id)
                    .read
                    .should
                    .beTrue();
              }
            }
          }
        });
      });

      when('the article update fails', () {
        late Result<Unit> result;

        before(() async {
          repo.fail = true;
          model = HomeViewModel(repo: repo);

          result =
              await model.markArticle(category.name, article.id, read: true);
        });

        then('a failure is returned', () {
          result.isError().should.beTrue();
        });
      });
    });
  });
}
