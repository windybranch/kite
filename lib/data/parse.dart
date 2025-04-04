import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:json_serializer/json_serializer.dart';

import '../config/serialisation.dart';
import 'article.dart';
import 'categories.dart';

/// Responsible for parsing JSON data into models.
final class Parser {
  static const _categoriesKey = 'categories';
  static const _articlesKey = 'clusters';

  /// Parses JSON data into a list of CategoryModel objects.
  Future<List<CategoryModel>> parseCategories(String json) {
    return compute(
      _decode<CategoryModel>,
      (content: json, key: _categoriesKey),
    );
  }

  /// Parses JSON data into a list of ArticleModel objects.
  Future<List<ArticleModel>> parseArticles(String json) {
    return compute(
      _decode<ArticleModel>,
      (content: json, key: _articlesKey),
    );
  }

  List<T> _decode<T>(({String content, String key}) json) {
    final models = <T>[];

    final decoded = jsonDecode(json.content) as Map<String, dynamic>;

    if (!decoded.containsKey(json.key)) return [];

    final data = [];

    try {
      data.addAll(decoded[json.key] as List<dynamic>);
    } on Exception catch (e) {
      log('error decoding json asset: $e');
      return [];
    }

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
