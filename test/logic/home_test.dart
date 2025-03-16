import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/logic/categories.dart';
import 'package:kite/logic/home.dart';
import 'package:kite/logic/repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shouldly/shouldly.dart';

const _kCategories = [
  Category('Technology'),
  Category('Science'),
  Category('Sports'),
];

class FakeRepository implements Repository {
  final bool fail;

  FakeRepository({this.fail = false});

  @override
  AsyncResult<List<Category>> loadCategories() {
    return fail
        ? Future.value(Failure(Exception('Failed')))
        : Future.value(Success(_kCategories));
  }
}

void main() {
  group('test home logic', () {
    given('a list of categories', () {
      const categories = _kCategories;

      when('loading', () {
        final repo = FakeRepository();
        final model = HomeViewModel(repo: repo);

        before(() async {
          await model.load.execute();
          model.load.isSuccess.should.beTrue();
        });

        then('the categories are returned', () {
          model.categories.should.be(categories);
        });
      });

      when('loading fails', () {
        final repo = FakeRepository(fail: true);
        final model = HomeViewModel(repo: repo);

        before(() async {
          await model.load.execute();
          model.load.isFailure.should.beTrue();
        });

        then('the categories are empty', () {
          model.categories.should.beEmpty();
        });
      });
    });
  });
}
