/// API data model class representing a category.
final class CategoryModel {
  const CategoryModel(this._name, this._file);

  final String _name;
  final String _file;

  /// The name of the category.
  String get name => _name;

  /// The file name of the source JSON file.
  ///
  /// In the form `<category_name>.json`.
  String get file => _file;
}
