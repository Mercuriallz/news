import "package:equatable/equatable.dart";

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchArticlesEvent extends SearchEvent {
  final String query;

  const SearchArticlesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchSourcesEvent extends SearchEvent {
  final String query;

  const SearchSourcesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LoadMoreSearchArticles extends SearchEvent {
  const LoadMoreSearchArticles();
}