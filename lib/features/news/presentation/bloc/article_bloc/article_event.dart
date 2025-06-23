import "package:equatable/equatable.dart";

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class LoadArticles extends ArticleEvent {
  final String sourceId;

  const LoadArticles({required this.sourceId});

  @override
  List<Object> get props => [sourceId];
}

class LoadMoreArticles extends ArticleEvent {
  const LoadMoreArticles();
}