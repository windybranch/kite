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

            return Column(
              children: [
                Flexible(
                  child: CategoriesView(
                    widget.model.categories,
                    selected ?? widget.model.categories.first,
                    onSelected: (category) {
                      setState(() {
                        selected = category;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ArticlesView(
                    selected ?? widget.model.categories.first,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
