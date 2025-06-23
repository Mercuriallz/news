import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/article.dart";
import "source_model.dart";

class ArticleModel extends Equatable {
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  const ArticleModel({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(json["source"] ?? {}),
      author: json["author"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ?? "",
      publishedAt: DateTime.parse(json["publishedAt"] ?? DateTime.now().toString()),
      content: json["content"] ?? "",
    );
  }

  factory ArticleModel.fromEntity(Article entity) {
    return ArticleModel(
      source: SourceModel.fromEntity(entity.source),
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }

  Article toEntity() {
    return Article(
      source: source.toEntity(),
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
    );
  }

  @override
  List<Object> get props => [
        source,
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];
}