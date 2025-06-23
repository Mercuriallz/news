import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/article.dart";
import "package:test_news/features/news/domain/entities/source.dart";


class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class ArticlesSearchLoaded extends SearchState {
  final List<Article> articles;
  final int page;
  final bool hasReachedMax;
  final String query;

  const ArticlesSearchLoaded({
    required this.articles,
    this.page = 1,
    this.hasReachedMax = false,
    required this.query,
  });

  ArticlesSearchLoaded copyWith({
    List<Article>? articles,
    int? page,
    bool? hasReachedMax,
    String? query,
  }) {
    return ArticlesSearchLoaded(
      articles: articles ?? this.articles,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [articles, page, hasReachedMax, query];
}

class SourcesSearchLoaded extends SearchState {
  final List<Source> sources;
  final String query;

  const SourcesSearchLoaded({
    required this.sources,
    required this.query,
  });

  @override
  List<Object> get props => [sources, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}