import 'package:result_dart/result_dart.dart';

import 'categories.dart';

/// Defines the repository interface to handle article data.
abstract interface class Repository {
  /// Loads a list of [Category]s.
  AsyncResult<List<Category>> loadCategories();

  /// Updates an article within a specific category.
  ///
  /// Returns the updated list of [Category]s.
  AsyncResult<List<Category>> updateReadStatus(
    String categoryName,
    String articleId, {
    required bool read,
  });
}
