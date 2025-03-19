import 'package:result_dart/result_dart.dart';

import 'article.dart';
import 'categories.dart';

/// Defines an interface for a service that provides category and article data.
abstract interface class Service {
  /// Returns a list of categories if successful.
  AsyncResult<List<CategoryModel>> fetchCategories();

  /// Returns a list of articles for a given category.
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category);
}
