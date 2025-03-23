import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/theme.dart';
import '../logic/article.dart';
import '../logic/categories.dart';
import 'core/circle_button.dart';
import 'core/spacing.dart';

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

          return InkWell(
            onTap: () => _DetailView.show(context, item),
            child: _SummaryView(
              title: item.title,
              group: item.group,
              readTime: item.readTime().toString(),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({
    super.key,
    required this.title,
    required this.group,
    required this.readTime,
  });

  final String title;
  final String group;
  final String readTime;

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
              Spacing.s4,
              Flexible(
                child: Text(
                  title,
                  style: Styles.title,
                ),
              ),
              Spacing.s8,
              Row(
                spacing: 4,
                children: [
                  Icon(
                    LucideIcons.hourglass,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  Text(
                    '$readTime $_timeToReadText',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacing.s16,
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

class _DetailView extends StatelessWidget {
  const _DetailView(this.article, {super.key});

  final Article article;

  /// Displays the article in a bottom sheet.
  static Future<_DetailView?> show(BuildContext context, Article article) {
    return showModalBottomSheet<_DetailView>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return _DetailView(article);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  CircleButton(
                    icon: LucideIcons.x,
                    color: Colors.grey.shade600,
                    backgroundColor: Colors.grey.shade200,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(
                          article.group,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      Spacing.s4,
                      Text(
                        article.title,
                        style: Styles.title,
                      ),
                      Spacing.s16,
                      Text(
                        article.summary,
                        style: Styles.body,
                      ),
                      Spacing.s16,
                      _HighlightsCard(article.highlights),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  const _HighlightsCard(this.highlights, {super.key});

  final List<Highlight> highlights;

  static const _highlightsTitle = 'Highlights';

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Colors.grey.shade50,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _highlightsTitle,
              style: Styles.subtitle,
            ),
            Spacing.s16,
            ...highlights.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          CircleButton(
                            icon: LucideIcons.star,
                            color: Colors.grey.shade600,
                            backgroundColor: Colors.grey.shade200,
                            onPressed: () {},
                          ),
                          Text(
                            h.title,
                            style: Styles.minititle,
                          ),
                        ],
                      ),
                      Text(
                        h.content,
                        style: Styles.body,
                      ),
                      // Don't display divider after last highlight
                      if (h != highlights[highlights.length - 1])
                        Divider(
                          color: Colors.grey.shade200,
                        ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
