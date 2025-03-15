import 'package:result_dart/result_dart.dart';

import 'categories.dart';

/// Defines an interface for a service that provides category and article data.
abstract interface class Service {
  /// Returns a list of categories if successful.
  AsyncResult<List<CategoryModel>> fetchCategories();
}
