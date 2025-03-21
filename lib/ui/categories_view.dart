import 'package:flutter/material.dart';

import '../logic/categories.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView(this.categories, {super.key});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: Text(item.name),
          ),
        );
      },
    );
  }
}
