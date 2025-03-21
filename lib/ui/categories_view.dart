import 'package:flutter/material.dart';

import '../logic/categories.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView(
    this.categories,
    this.selected, {
    this.onSelected,
    super.key,
  });

  final List<Category> categories;
  final Category selected;
  final ValueChanged<Category>? onSelected;

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
          child: ChoiceChip(
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: Text(item.name),
            selected: selected == item,
            onSelected: (selected) => selected ? onSelected?.call(item) : null,
          ),
        );
      },
    );
  }
}
