import 'package:equatable/equatable.dart';

/// Represents an article.
final class Article with EquatableMixin {
  const Article({
    required this.group,
    required this.title,
    required this.summary,
    required this.highlights,
    required this.quote,
    required this.perspectives,
    required this.background,
    required this.reactions,
    required this.timeline,
    required this.sources,
    required this.fact,
  });

  /// The subcategory of the article.
  ///
  /// Different to the main [Category].
  final String group;

  /// The title of the article.
  final String title;

  /// A short summary of the article.
  final String summary;

  /// The highlights of the article.
  final List<Highlight> highlights;

  /// A quote associated with the article.
  final Quote quote;

  /// Perspectives related to the article.
  final List<Perspective> perspectives;

  /// Historical background information related to the article.
  final String background;

  /// International reactions related to the article.
  final List<Reaction> reactions;

  /// Timeline events related to the article.
  final List<Event> timeline;

  /// Sources used for the article.
  final List<Source> sources;

  /// A fact related to the article (Did you know?).
  final String fact;

  /// Estimates reading time of the article.
  int readTime() {
    throw UnimplementedError('readTime() is not implemented');
  }

  @override
  List<Object?> get props => [
        group,
        title,
        summary,
        highlights,
        quote,
        perspectives,
        background,
        reactions,
        timeline,
        sources,
        fact,
      ];
}

/// Represents an article highlight.
typedef Highlight = ({String title, String content});

/// Represents an article quote.
typedef Quote = ({String author, String content, String url, String domain});

/// Represents an article perspective.
typedef Perspective = ({String title, String text, List<Source> sources});

/// Represents an online source.
typedef Source = ({String name, String url, String? domain, DateTime? date});

/// Represents an international reactions related to the article.
typedef Reaction = ({String title, String content});

/// Represents a timeline event.
typedef Event = ({String date, String title});
