import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/category.dart";

class CategoryModel extends Equatable {
  final String name;
  final String displayName;

  const CategoryModel({
    required this.name,
    required this.displayName,
  });

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      name: entity.name,
      displayName: entity.displayName,
    );
  }

  Category toEntity() {
    return Category(
      name: name,
      displayName: displayName,
    );
  }

  @override
  List<Object> get props => [name, displayName];
}