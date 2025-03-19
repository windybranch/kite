import 'package:kite/data/service_local.dart';
import 'package:result_dart/result_dart.dart';

class FakeLoader implements AssetLoader {
  FakeLoader(this.successJson, {this.fail = false});

  bool fail;
  String successJson;

  @override
  AsyncResult<String> loadAsset(String path) {
    return fail
        ? Future.value(Failure(Exception('failed to load asset')))
        : Future.value(Success(successJson));
  }
}
