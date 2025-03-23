import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:json_serializer/json_serializer.dart';

import '../config/serialisation.dart';
import 'categories.dart';

/// Responsible for parsing JSON data into models.
final class Parser {
  static const _categoriesKey = 'categories';

  /// Parses JSON data into a list of CategoryModel objects.
  Future<List<CategoryModel>> parseCategories(String json) {
    return compute(
      _decode<CategoryModel>,
      (content: json, key: _categoriesKey),
    );
  }

  List<T> _decode<T>(({String content, String key}) json) {
    final models = <T>[];

    final decoded = jsonDecode(json.content) as Map<String, dynamic>;
    final data = decoded[json.key] as List<dynamic>;

    for (final (item as Map<String, dynamic>) in data) {
      final encoded = jsonEncode(item);
      try {
        final model = deserialize<T>(encoded, JsonConfig.options);
        models.add(model);
      } catch (e) {
        log('error decoding json asset: $e');
      }
    }

    return models;
  }
}
