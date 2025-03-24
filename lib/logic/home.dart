import 'dart:collection';
import 'dart:developer';

import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import 'categories.dart';
import 'repository.dart';

/// Handles the logic for the home View.
class HomeViewModel {
  HomeViewModel({required Repository repo}) : _repo = repo {
    load = Command0(_load)..execute();
  }

  final Repository _repo;
  final List<Category> _categories = [];

  /// Command wrapper to load categories.
  late Command0<Unit> load;

  /// Returns the list of categories.
  ///
  /// Empty by default.
  UnmodifiableListView<Category> get categories =>
      UnmodifiableListView(_categories);

  /// Loads the categories to display.
  AsyncResult<Unit> _load() async {
    final result = await _repo.loadCategories();
    if (result.isError()) {
      final err = result.exceptionOrNull();
      log('error loading categories: $err');
      return Failure(err!);
    }

    final categories = result.getOrNull();
    if (categories != null) {
      _categories.clear();
      _categories.addAll(categories);
    }

    return Success(unit);
  }

  /// Retry loading the categories.
  ///
  /// Currently a wrapper around the load command.
  Future<void> retry() {
    return load.execute();
  }

  /// Updates the article to mark it as read or unread.
  AsyncResult<Unit> markArticle(
    String categoryName,
    String articleId, {
    required bool read,
  }) async {
    final result =
        await _repo.updateReadStatus(categoryName, articleId, read: read);

    final updated = result.getOrNull() ?? [];
    log('returned updated categories: articleId: $articleId, length: ${updated.length}');

    if (updated.isNotEmpty) {
      _categories.clear();
      _categories.addAll(updated);
    }

    return Future.value(Success(unit));
  }
}
