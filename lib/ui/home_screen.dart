import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

import '../logic/categories.dart';
import '../logic/home.dart';
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
                  child: ListView.builder(
                    itemCount: selected?.articles.length ??
                        widget.model.categories.first.articles.length,
                    itemBuilder: (context, index) {
                      final category =
                          selected ?? widget.model.categories.first;
                      final item = category.articles[index];

                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(item.title),
                        ),
                        subtitle: Text(item.group),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
