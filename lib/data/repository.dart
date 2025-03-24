import 'dart:developer';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

import '../logic/article.dart';
import '../logic/categories.dart';
import '../logic/repository.dart';
import 'article.dart';
import 'categories.dart';
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

    final List<Category> categories = [];

    for (final model in models) {
      final result = await _loadArticles(model);
      if (result.isError()) {
        final err = result.exceptionOrNull();
        log('error loading articles for category: ${model.name} in file ${model.file}: $err');
        return Future.value(Failure(err!));
      }

      final articles = result.getOrNull() ?? [];
      if (articles.isEmpty) log('articles empty for category: ${model.name}');

      categories.add(Category(model.name, articles));
    }

    _cached.addAll(categories);

    return Future.value(Success(categories));
  }

  AsyncResult<List<Article>> _loadArticles(CategoryModel category) async {
    final result = await _service.fetchArticles(category);
    if (result.isError()) {
      final err = result.exceptionOrNull();
      return Future.value(Failure(err!));
    }

    final models = result.getOrNull() ?? [];
    if (models.isEmpty) {
      log('no articles found via service for category: ${category.name} in file ${category.file}');
    }

    try {
      final articles = _parseArticles(models);
      return Future.value(Success(articles));
    } on Exception catch (e, stackTrace) {
      log('error parsing articles for category: ${category.name} in file ${category.file}: $e');
      log('stack trace: $stackTrace');
      return Future.value(Failure(e));
    }
  }

  List<Article> _parseArticles(List<ArticleModel> models) {
    return models.map((m) => _parseArticle(m)).toList();
  }

  Article _parseArticle(ArticleModel model) {
    return Article(
      id: Uuid().v4(),
      group: model.category,
      title: model.title,
      summary: model.short_summary,
      highlights: model.talking_points.map(_parseHightlight).toList(),
      quote: (
        author: model.quote_author,
        content: model.quote,
        domain: model.quote_source_domain,
        url: model.quote_source_url,
      ),
      perspectives: model.perspectives.map(_parsePerspective).toList(),
      background: model.historical_background,
      reactions: model.international_reactions.map(_parseReaction).toList(),
      timeline: model.timeline.map(_parseTimeline).toList(),
      sources: model.articles.map(_parseSource).toList(),
      fact: model.did_you_know,
    );
  }

  Perspective _parsePerspective(ArticlePerspectiveModel model) {
    // Comes in the form "Title: Content".
    final (title, text) = _splitString(model.text);

    return (
      title: title,
      text: text,
      sources: model.sources
          .map((s) => (
                name: s["name"] ?? "",
                url: s["url"] ?? "",
                domain: null,
                date: null
              ))
          .toList(),
    );
  }

  Source _parseSource(ArticleSourceModel model) {
    return (
      name: model.title,
      url: model.link,
      domain: model.domain,
      date: DateTime.tryParse(model.date),
    );
  }

  Highlight _parseHightlight(String highlight) {
    // Comes in the form "Title: Content".
    final (title, content) = _splitString(highlight);

    return (title: title, content: content);
  }

  Reaction _parseReaction(String reaction) {
    // Comes in the form "Title: Content".
    final (title, content) = _splitString(reaction);

    return (title: title, content: content);
  }

  Event _parseTimeline(String event) {
    // Comes in the form "Title: Content".
    final (date, title) = _splitString(event, delimiter: ':: ');

    return (date: date, title: title);
  }

  /// Splits a string in two parts using the delimiter.
  ///
  /// Returns a record containg the first part [a] and the second part [b].
  ///
  /// If the string cannot be split, returns the original string as [a],
  /// and an empty string as [b].
  (String a, String b) _splitString(String input, {String delimiter = ': '}) {
    final split = input.split(delimiter);
    if (split.length == 2) {
      return (split[0], split[1]);
    }
    return (input, '');
  }

  @override
  AsyncResult<List<Category>> updateReadStatus(
    String categoryName,
    String articleId, {
    required bool read,
  }) {
    // TODO: implement updateArticle
    throw UnimplementedError();
  }
}
