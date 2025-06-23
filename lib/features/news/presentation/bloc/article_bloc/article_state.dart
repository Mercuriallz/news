import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/article.dart";

class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<Article> articles;
  final int page;
  final bool hasReachedMax;

  const ArticleLoaded({
    required this.articles,
    this.page = 1,
    this.hasReachedMax = false,
  });

  ArticleLoaded copyWith({
    List<Article>? articles,
    int? page,
    bool? hasReachedMax,
  }) {
    return ArticleLoaded(
      articles: articles ?? this.articles,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [articles, page, hasReachedMax];
}

class ArticleError extends ArticleState {
  final String message;

  const ArticleError({required this.message});

  @override
  List<Object> get props => [message];
}