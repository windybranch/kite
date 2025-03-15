import 'package:kite/data/categories.dart';
import 'package:result_dart/result_dart.dart';

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
  AsyncResult<List<CategoryModel>> fetchCategories() {
    // TODO: implement fetchCategories
    throw UnimplementedError();
  }
}
