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
  static const serverError = 500;
}

/// Implements the [Service] interface for remote data fetching.
class RemoteService implements Service {
  const RemoteService(this._client);

  final http.Client _client;

  @override
  AsyncResult<List<ArticleModel>> fetchArticles(CategoryModel category) async {
    final response = await _client.get(Uri.parse(_Url.create(category.file)));

    if (response.statusCode == HttpStatus.ok) {
      final json = response.body;
      final parser = Parser();
      try {
        final articles = await parser.parseArticles(json);
        return Future.value(Success(articles));
      } on Exception catch (e) {
        log('error parsing categories $e');
        return Future.value(Failure(e));
      }
    }

    return switch (response.statusCode) {
      HttpStatus.serverError => Future.value(
          Failure(_HttpErrors.serverError(
              response.statusCode, _Url.create(category.file))),
        ),
      _ => Future.value(
          Failure(_HttpErrors.error(
              response.statusCode, _Url.create(category.file))),
        ),
    };
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
        return Future.value(Failure(e));
      }
    }

    return switch (response.statusCode) {
      HttpStatus.serverError => Future.value(
          Failure(
            _HttpErrors.serverError(response.statusCode, _Url.categories),
          ),
        ),
      _ => Future.value(
          Failure(_HttpErrors.error(response.statusCode, _Url.categories)),
        ),
    };
  }
}

abstract final class _Url {
  static const categories = 'https://kite.kagi.com/kite.json';
  static const base = 'https://kite.kagi.com';

  static String create(String file) => '$base/$file';
}

abstract final class _HttpErrors {
  static serverError(int code, String url) => Exception(
        'Internal Server Error fetching categories from $url: status $code',
      );

  static error(int code, String url) =>
      Exception('Unknown error fetching categories from $url: status $code');
}
