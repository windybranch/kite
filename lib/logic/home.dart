import 'dart:collection';

import 'package:result_dart/result_dart.dart';

import 'categories.dart';
import 'repository.dart';

/// Handles the logic for the home View.
class HomeViewModel {
  HomeViewModel({required Repository repo}) : _repo = repo;

  final Repository _repo;
  final List<Category> _categories = [];

  /// Returns the list of categories.
  ///
  /// Empty by default.
  UnmodifiableListView<Category> get categories =>
      UnmodifiableListView(_categories);

  /// Loads the categories to display.
  AsyncResult<Unit> load() async {
    throw UnimplementedError();
  }
}
