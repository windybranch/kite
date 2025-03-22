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

          return _SummaryView(
            title: item.title,
            group: item.group,
          );
        },
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({super.key, required this.title, required this.group});

  final String title;
  final String group;

  static const _timeToReadText = 'min read';

  @override
  Widget build(BuildContext context) {
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
                    label: Text(
                      group,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
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
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: -1.0,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                spacing: 8,
                children: [
                  Icon(
                    LucideIcons.hourglass,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  Text(
                    '? $_timeToReadText',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey.shade200,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
