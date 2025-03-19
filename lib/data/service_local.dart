import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;
import 'package:json_serializer/json_serializer.dart';
import 'package:kite/data/article.dart';
import 'package:kite/data/categories.dart';
import 'package:result_dart/result_dart.dart';

import '../config/serialisation.dart';
import 'service.dart';

/// Defines an interface for loading local assets.
abstract interface class AssetLoader {
  /// Loads an asset from the local file system.
  AsyncResult<String> loadAsset(String path);
}

/// Implements the [Service] interface using local data.
class LocalService implements Service {
  LocalService(this._loader);

  final AssetLoader _loader;

  @override
  AsyncResult<List<CategoryModel>> fetchCategories() async {
    final result = await _loader.loadAsset(_Assets.categories);
    if (result.isError()) {
      final err = result.exceptionOrNull();
      log('error loading json categories asset: $err');
      return Future.value(Failure(err!));
    }

    final json = result.getOrNull() ?? '';
    if (json.isEmpty) log('json categories asset is null');

    final models = <CategoryModel>[];
    try {
      models.addAll(_decode<CategoryModel>(json, 'categories'));
    } on FormatException catch (e) {
      log('error decoding json categories asset: $e');
      return Future.value(Failure(e));
    }

    return Future.value(Success(models));
  }

  @override
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category) async {
    final result = await _loader.loadAsset(_Assets.articles);
    if (result.isError()) {
      final err = result.exceptionOrNull();
      log('error loading json articles asset: $err');
      return Future.value(Failure(err!));
    }

    final json = result.getOrNull() ?? '';
    if (json.isEmpty) log('json articles asset is null');

    final models = <ArticleModel>[];
    try {
      models.addAll(_decode<ArticleModel>(json, 'clusters'));
    } on FormatException catch (e) {
      log('error decoding json articles asset: $e');
      return Future.value(Failure(e));
    }

    return Future.value(Success(models));
  }

  List<T> _decode<T>(String json, String jsonKey) {
    final models = <T>[];

    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final data = decoded[jsonKey] as List<dynamic>;

    for (final (item as Map<String, dynamic>) in data) {
      final encoded = jsonEncode(item);
      final model = deserialize<T>(encoded, JsonConfig.options);
      models.add(model);
    }

    return models;
  }
}

abstract final class _Assets {
  static const String categories = 'assets/kite.json';
  static const String articles = 'assets/world.json';
}

class LocalAssetLoader implements AssetLoader {
  @override
  AsyncResult<String> loadAsset(String path) async {
    try {
      final data = await rootBundle.loadString(path);
      return Success(data);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
