import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;
import 'package:json_serializer/json_serializer.dart';
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
    models.addAll(_decodeCategories(json));

    return Future.value(Success(models));
  }

  List<CategoryModel> _decodeCategories(String json) {
    final models = <CategoryModel>[];

    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final categories = decoded['categories'] as List<dynamic>;

    for (final (category as Map<String, dynamic>) in categories) {
      final encoded = jsonEncode(category);
      final model = deserialize<CategoryModel>(encoded, JsonConfig.options);
      models.add(model);
    }

    return models;
  }
}

abstract final class _Assets {
  static const String categories = 'assets/kite.json';
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
