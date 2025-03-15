import 'package:equatable/equatable.dart';
import 'package:json_serializer/json_serializer.dart';

/// API data model class representing a category.
final class CategoryModel with EquatableMixin implements Serializable {
  const CategoryModel({required this.name, required this.file});

  /// The name of the category.
  final String name;

  /// The file name of the source JSON file.
  ///
  /// In the form `<category_name>.json`.
  final String file;

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'file': file,
      };

  @override
  List<Object?> get props => [name, file];
}
