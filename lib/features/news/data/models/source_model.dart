import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/source.dart";

class SourceModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String language;
  final String country;

  const SourceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.language,
    required this.country,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
      category: json["category"] ?? "",
      language: json["language"] ?? "",
      country: json["country"] ?? "",
    );
  }

  factory SourceModel.fromEntity(Source entity) {
    return SourceModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      url: entity.url,
      category: entity.category,
      language: entity.language,
      country: entity.country,
    );
  }

  Source toEntity() {
    return Source(
      id: id,
      name: name,
      description: description,
      url: url,
      category: category,
      language: language,
      country: country,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        url,
        category,
        language,
        country,
      ];
}