import 'package:equatable/equatable.dart';

/// Represents a category of articles.
///
/// Holds a list of [Article]s for the given category.
class Category with EquatableMixin {
  const Category(this._name);

  final String _name;

  /// Returns the name of the category.
  String get name => _name;

  @override
  List<Object?> get props => [_name];
}
