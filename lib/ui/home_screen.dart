import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

import '../logic/categories.dart';
import '../logic/home.dart';
import 'articles_view.dart';
import 'categories_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.model});

  final HomeViewModel model;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.model.load,
          builder: (context, _) {
            if (widget.model.load.isRunning) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.model.load.isFailure) {
              return Center(
                child: Text((widget.model.load.value as FailureCommand)
                    .error
                    .toString()),
              );
            }

            return _SuccessView(
              widget.model.categories,
              selected ?? widget.model.categories.first,
              (category) {
                setState(() {
                  selected = category;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView(
    this._categories,
    this.selected,
    this.onSelected, {
    super.key,
  });

  final Category selected;
  final List<Category> _categories;
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          forceMaterialTransparency: true,
          flexibleSpace: CategoriesView(
            _categories,
            selected,
            onSelected: onSelected,
          ),
        ),
        ArticlesView(selected),
      ],
    );
  }
}
