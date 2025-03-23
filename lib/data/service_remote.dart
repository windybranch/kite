import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:kite/data/article.dart';

import 'package:kite/data/categories.dart';
import 'package:result_dart/result_dart.dart';

import 'parse.dart';
import 'service.dart';

/// Provides getters for HTTP status codes.
///
/// e.g. HttpStatus.ok = 200.
abstract final class HttpStatus {
  static const ok = 200;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const internalServerError = 500;
}

/// Implements the [Service] interface for remote data fetching.
class RemoteService implements Service {
  const RemoteService(this._client);

  final http.Client _client;

  @override
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category) {
    // TODO: implement fetchArticles
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<CategoryModel>> fetchCategories() async {
    final response = await _client.get(Uri.parse(_Url.categories));

    if (response.statusCode == HttpStatus.ok) {
      final json = response.body;
      final parser = Parser();
      try {
        final categories = await parser.parseCategories(json);
        return Future.value(Success(categories));
      } on Exception catch (e) {
        log('error parsing categories $e');
        // TODO: handle the exception
      }
    }

    // TODO: implement fetchCategories
    throw UnimplementedError();
  }
}

abstract final class _Url {
  static const categories = 'https://kite.kagi.com/kite.json';
}
