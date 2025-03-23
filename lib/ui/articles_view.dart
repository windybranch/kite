import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
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
                      style: Styles.chip,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: Colours.chipBorder),
                  ),
                  CircleButton.tight(
                    icon: LucideIcons.check,
                    color: Colors.white,
                    backgroundColor: Colors.grey.shade200,
                    onPressed: () {},
                  ),
                ],
              ),
              Spacing.s8,
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
                    color: Colours.icon,
                    size: 18,
                  ),
                  Text(
                    '$readTime $_timeToReadText',
                    style: Styles.metadata,
                  ),
                ],
              ),
              Spacing.s16,
              Divider(
                color: Colours.divider,
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
                    color: Colours.iconButton,
                    backgroundColor: Colours.iconButtonBg,
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
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      Spacing.s4,
                      Text(
                        article.title,
                        style: Styles.title,
                      ),
                      Spacing.s24,
                      Text(
                        article.summary,
                        style: Styles.body,
                      ),
                      Spacing.s24,
                      _HighlightsCard(article.highlights),
                      Spacing.s24,
                      _QuoteCard(article.quote),
                      Spacing.s24,
                      _PerspectivesCard(article.perspectives),
                      Spacing.s24,
                      _TimelineCard(article.timeline),
                      Spacing.s24,
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
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
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
                          color: Colours.divider,
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

class _QuoteCard extends StatelessWidget {
  const _QuoteCard(this.quote, {super.key});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleButton(
              icon: LucideIcons.quote,
              color: Colours.iconButton,
              backgroundColor: Colours.iconButtonBg,
              onPressed: () {},
            ),
            Spacing.s12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                    child: Text(
                      quote.content,
                      style: Styles.body,
                    ),
                  ),
                  Spacing.s4,
                  Text(
                    '—${quote.author}',
                    style: Styles.metadata,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerspectivesCard extends StatelessWidget {
  const _PerspectivesCard(this.perspectives, {super.key});

  final List<Perspective> perspectives;

  static const _perspectivesTitle = 'Perspectives';

  String _domain(String url) {
    final uri = Uri.parse(url);
    final host = uri.host;

    if (host.startsWith('www.')) {
      return host.substring(4);
    }

    return host;
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                _perspectivesTitle,
                style: Styles.subtitle,
              ),
            ),
            Spacing.s16,
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...perspectives.map(
                        (perspective) => Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Card.filled(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(LucideIcons.sparkle),
                                    Spacing.s8,
                                    Text(
                                      perspective.title,
                                      style: Styles.minititle,
                                    ),
                                    Spacing.s8,
                                    Flexible(
                                      child: Text(
                                        perspective.text,
                                        style: Styles.body,
                                      ),
                                    ),
                                    Spacing.s8,
                                    ...perspective.sources.map(
                                      (s) => GestureDetector(
                                        onTap: () async {
                                          await launchUrl(Uri.parse(s.url));
                                        },
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              LucideIcons.arrowUpRightSquare,
                                              color: Colours.icon,
                                              size: 18,
                                            ),
                                            Text(
                                              _domain(s.url),
                                              style: Styles.metadata,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard(this.timeline, {super.key});

  final List<Event> timeline;

  static const _timelineTitle = 'Timeline of events';

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                _timelineTitle,
                style: Styles.subtitle,
              ),
            ),
            Spacing.s16,
            ...timeline.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleButton(
                                icon: LucideIcons.calendar,
                                color: Colors.grey.shade600,
                                backgroundColor: Colors.grey.shade200,
                                onPressed: () {},
                              ),
                              Spacing.s4,
                              // Don't show the last line.
                              if (e != timeline[timeline.length - 1])
                                Flexible(
                                  child: Container(
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                )
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    e.date,
                                    style: Styles.minititle,
                                  ),
                                ),
                                Flexible(
                                  child: Text(e.title, style: Styles.body),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
