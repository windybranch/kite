import 'package:http/http.dart' as http;
import 'package:kite/data/article.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/service.dart';
import 'package:kite/data/service_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'articles.dart';
import 'categories.dart';

const kWorldCategory = 'World';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpResponse extends Mock implements http.Response {}

/// Fake implementation of [Uri] for testing purposes.
///
/// Used with mocktail to allow argument matchers of [any].
///
/// Example usage:
/// ```dart
/// setUpAll(() {
///   registerFallbackValue(FakeUri());
/// });
/// ```
class FakeUri extends Fake implements Uri {}

class FakeLoader implements AssetLoader {
  FakeLoader(this.successJson, {this.fail = false});

  bool fail;
  String successJson;

  @override
  AsyncResult<String> loadAsset(String path) {
    return fail
        ? Future.value(Failure(Exception('failed to load asset')))
        : Future.value(Success(successJson));
  }
}

/// Enum to determine fail state for testing purposes.
enum Fail {
  none,
  categories,
  articles,
  all;

  bool get forArticles => this == Fail.articles || this == Fail.all;
}

class FakeService implements Service {
  Fail fail;

  FakeService([this.fail = Fail.none]);

  @override
  AsyncResult<List<CategoryModel>> fetchCategories() {
    final e = Exception('failed to fetch categories');

    return switch (fail) {
      Fail.categories || Fail.all => Future.value(Failure(e)),
      _ => Future.value(Success(kCategoryModels)),
    };
  }

  @override
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category) {
    if (fail.forArticles) {
      final e = Exception('failed to fetch articles');

      return Future.value(Failure(e));
    }

    return switch (category.name) {
      kWorldCategory => Future.value(Success(kArticleModels)),
      _ => Future.value(Success([])),
    };
  }
}
