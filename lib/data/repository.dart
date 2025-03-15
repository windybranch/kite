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
  AsyncResult<List<Category>> loadCategories() {
    // TODO: implement loadCategories
    throw UnimplementedError();
  }
}
