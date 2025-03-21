import 'package:flutter/material.dart';

import '../logic/categories.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView(this.categories, {super.key});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return ListTile(
          title: Text(item.name),
        );
      },
    );
  }
}
