import "package:bloc/bloc.dart";
import "package:test_news/features/news/domain/usecases/search_news.dart";
import "search_event.dart";
import "search_state.dart";

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticles searchArticles;
  final SearchSources searchSources;
  String currentQuery = "";

  SearchBloc({
    required this.searchArticles,
    required this.searchSources,
  }) : super(SearchInitial()) {
    on<SearchArticlesEvent>(_onSearchArticles);
    on<SearchSourcesEvent>(_onSearchSources);
    on<LoadMoreSearchArticles>(_onLoadMoreSearchArticles);
  }

  Future<void> _onSearchArticles(
    SearchArticlesEvent event,
    Emitter<SearchState> emit,
  ) async {
    currentQuery = event.query;
    emit(SearchLoading());
    final result = await searchArticles(event.query, 1);
    result.fold(
      (l) => emit(SearchError(message: l.message)),
      (r) => emit(
        ArticlesSearchLoaded(
          articles: r,
          page: 1,
          hasReachedMax: r.isEmpty,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onSearchSources(
    SearchSourcesEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchSources(event.query);
    result.fold(
      (l) => emit(SearchError(message: l.message)),
      (r) => emit(
        SourcesSearchLoaded(
          sources: r,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreSearchArticles(
    LoadMoreSearchArticles event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is ArticlesSearchLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.page + 1;
      final result = await searchArticles(currentQuery, nextPage);
      result.fold(
        (l) => emit(SearchError(message: l.message)),
        (r) {
          if (r.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(
              ArticlesSearchLoaded(
                articles: [...currentState.articles, ...r],
                page: nextPage,
                hasReachedMax: false,
                query: currentQuery,
              ),
            );
          }
        },
      );
    }
  }
}