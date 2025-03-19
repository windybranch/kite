import 'package:equatable/equatable.dart';
import 'package:json_serializer/json_serializer.dart';

/// A data model representing one of the main articles for a given [CategoryModel].
final class ArticleModel with EquatableMixin implements Serializable {
  // TODO: fix snake case naming.
  //
  // Due to a bug in the `json_serializer` package.
  // The class parameter name needs to match the json key,
  // otherwise deserialization will not work.
  //
  // Issue opened: https://github.com/edsonbonfim/json_serializer/issues/2
  const ArticleModel({
    required this.category,
    required this.title,
    required this.short_summary,
    required this.did_you_know,
    required this.talking_points,
    required this.quote,
    required this.quote_author,
    required this.quote_source_url,
    required this.quote_source_domain,
    required this.location,
    required this.perspectives,
    required this.emoji,
    required this.historical_background,
    required this.international_reactions,
    required this.timeline,
    required this.articles,
  });

  /// The name of the subcategory.
  ///
  /// Not the main [CategoryModel] linked to a list of articles.
  final String category;

  /// The title of the article.
  final String title;

  /// A short summary of the article.
  final String short_summary;

  /// A fact relating to the article (Did you know?).
  final String did_you_know;

  /// A list of talking points related to the article.
  final List<String> talking_points;

  /// A quote related to the article.
  final String quote;

  /// The author of the [quote].
  final String quote_author;

  /// The source URL of the [quote].
  final String quote_source_url;

  /// The source domain of the [quote].
  final String quote_source_domain;

  /// A location related to the article.
  final String location;

  /// Perspectives related to the article.
  final List<ArticlePerspectiveModel> perspectives;

  /// An emoji to represent a theme in the article.
  final String emoji;

  /// Historical background for context around the article.
  final String historical_background;

  /// International reactions to the article topic.
  ///
  /// In the form: 'title: content'.
  final List<String> international_reactions;

  /// Timeline of events related to the article.
  ///
  /// In the form: 'date:: description'.
  /// A text form date, not easy to parse.
  final List<String> timeline;

  /// Source articles used to create the main article.
  final List<ArticleSourceModel> articles;

  @override
  List<Object?> get props => [
        category,
        title,
        short_summary,
        did_you_know,
        talking_points,
        quote,
        quote_author,
        quote_source_url,
        quote_source_domain,
        location,
        perspectives,
        emoji,
        historical_background,
        international_reactions,
        timeline,
        articles,
      ];

  @override
  Map<String, dynamic> toMap() => {
        'category': category,
        'title': title,
        'short_summary': short_summary,
        'did_you_know': did_you_know,
        'talking_points': talking_points,
        'quote': quote,
        'quote_author': quote_author,
        'quote_source_url': quote_source_url,
        'quote_source_domain': quote_source_domain,
        'location': location,
        'perspectives': perspectives,
        'emoji': emoji,
        'historical_background': historical_background,
        'international_reactions': international_reactions,
        'timeline': timeline,
        'articles': articles,
      };
}

/// A data model representing a perspective related to the article.
final class ArticlePerspectiveModel
    with EquatableMixin
    implements Serializable {
  const ArticlePerspectiveModel({required this.text, required this.sources});

  /// The text containing the title and content.
  ///
  /// In the form: 'title: content'.
  final String text;

  /// A list of sources for the perspective.
  ///
  /// Each source is a map with keys `name` and `url`.
  final List<Map<String, String>> sources;

  @override
  List<Object?> get props => [text, sources];

  @override
  Map<String, dynamic> toMap() => {
        'text': text,
        'sources': sources,
      };
}

/// A data model representing a source article used to create the main article.
final class ArticleSourceModel with EquatableMixin implements Serializable {
  const ArticleSourceModel({
    required this.title,
    required this.link,
    required this.domain,
    required this.date,
    required this.image,
    required this.image_caption,
  });

  /// The title of the source article.
  final String title;

  /// The link to the source article.
  final String link;

  /// The domain of the source article.
  final String domain;

  /// The date of the source article.
  ///
  /// In the form: yyyy-MM-ddTHH:mm:ssZ
  final String date;

  /// A URL to an image related to the source article.
  final String image;

  /// A caption for the related [image].
  final String image_caption;

  @override
  List<Object?> get props => [title, link, domain, date, image, image_caption];

  @override
  Map<String, dynamic> toMap() => {
        'title': title,
        'link': link,
        'domain': domain,
        'date': date,
        'image': image,
        'image_caption': image_caption,
      };
}
