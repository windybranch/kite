import 'package:flutter/material.dart';

import '../logic/categories.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: category.articles.length,
      itemBuilder: (context, index) {
        final item = category.articles[index];

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(item.title),
          ),
          subtitle: Text(item.group),
        );
      },
    );
  }
}
