import "package:bloc/bloc.dart";
import "package:test_news/features/news/domain/usecases/get_articles.dart";
import "article_event.dart";
import "article_state.dart";

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticlesBySource getArticlesBySource;
  String currentSourceId = "";

  ArticleBloc({required this.getArticlesBySource}) : super(ArticleInitial()) {
    on<LoadArticles>(onLoadArticles);
    on<LoadMoreArticles>(onLoadMoreArticles);
  }

  Future<void> onLoadArticles(
    LoadArticles event,
    Emitter<ArticleState> emit,
  ) async {
    currentSourceId = event.sourceId;
    emit(ArticleLoading());
    final result = await getArticlesBySource(event.sourceId, 1);
    result.fold(
      (l) => emit(ArticleError(message: l.message)),
      (r) => emit(
        ArticleLoaded(
          articles: r,
          page: 1,
          hasReachedMax: r.isEmpty,
        ),
      ),
    );
  }

  Future<void> onLoadMoreArticles(
    LoadMoreArticles event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;
    if (currentState is ArticleLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.page + 1;
      final result = await getArticlesBySource(currentSourceId, nextPage);
      result.fold(
        (l) => emit(ArticleError(message: l.message)),
        (articles) {
          if (articles.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(
              ArticleLoaded(
                articles: [...currentState.articles, ...articles],
                page: nextPage,
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    }
  }
}