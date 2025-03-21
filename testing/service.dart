import 'package:kite/data/article.dart';
import 'package:kite/data/categories.dart';
import 'package:kite/data/service.dart';
import 'package:kite/data/service_local.dart';
import 'package:result_dart/result_dart.dart';

import 'articles.dart';
import 'categories.dart';

const kWorldCategory = 'World';

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

class FakeService implements Service {
  bool fail;

  FakeService({this.fail = false});

  @override
  AsyncResult<List<CategoryModel>> fetchCategories() {
    return fail
        ? Future.value(Failure(Exception('failed to fetch categories')))
        : Future.value(Success(kCategoryModels));
  }

  @override
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category) {
    return switch (category.name) {
      kWorldCategory => Future.value(Success(kArticleModels)),
      _ => Future.value(Success([])),
    };
  }
}
