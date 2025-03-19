import 'package:json_serializer/json_serializer.dart';

import '../data/article.dart';
import '../data/categories.dart';

/// Configuration for JSON serialisation.
abstract final class JsonConfig {
  /// Defines custom types for JSON serialisation.
  ///
  /// Pass as options param when using [deserialize].
  /// Removes the need for code generation.
  static final options = JsonSerializerOptions(types: [
    UserType<CategoryModel>(CategoryModel.new),
    UserType<ArticleModel>(ArticleModel.new),
    UserType<ArticlePerspectiveModel>(ArticlePerspectiveModel.new),
    UserType<ArticleSourceModel>(ArticleSourceModel.new),
  ]);
}
