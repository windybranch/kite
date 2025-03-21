import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'article.dart';

/// Represents a category of articles.
///
/// Holds a list of [Article]s for the given category.
final class Category with EquatableMixin {
  const Category(this.name, this._articles);

  /// The name of the category.
  ///
  /// e.g. "Technology", "Science", "World"
  final String name;

  final List<Article> _articles;

  /// The articles for the category.
  UnmodifiableListView<Article> get articles => UnmodifiableListView(_articles);

  @override
  List<Object?> get props => [name, _articles];
}
