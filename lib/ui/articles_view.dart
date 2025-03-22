import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../logic/categories.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: category.articles.length,
        (context, index) {
          final item = category.articles[index];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(item.group),
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 14,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            icon: Icon(
                              LucideIcons.check,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          letterSpacing: -1.0,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 14,
                          child: IconButton(
                            padding: EdgeInsets.only(top: 4),
                            iconSize: 20,
                            icon: Icon(
                              LucideIcons.chevronDown,
                              color: Colors.black87,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
