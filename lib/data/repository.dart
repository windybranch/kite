import 'dart:developer';

import 'package:result_dart/result_dart.dart';

import '../logic/categories.dart';
import '../logic/repository.dart';
import 'service.dart';

/// Fetches categories via the [Service] and caches them locally.
class CacheRepository implements Repository {
  CacheRepository(this._service);

  final Service _service;

  final List<Category> _cached = [];

  @override
  AsyncResult<List<Category>> loadCategories() async {
    if (_cached.isNotEmpty) {
      return Future.value(Success(_cached));
    }

    final result = await _service.fetchCategories();
    if (result.isError()) {
      final err = result.exceptionOrNull();
      log('error fetching categories via service: $err');
      return Future.value(Failure(err!));
    }

    final models = result.getOrNull() ?? [];
    if (models.isEmpty) {
      log('no categories found via service');
    }

    final List<Category> categories =
        models.map((m) => Category(m.name, [])).toList();
    _cached.addAll(categories);

    return Future.value(Success(categories));
  }
}
