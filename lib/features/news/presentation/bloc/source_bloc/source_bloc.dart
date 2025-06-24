import "package:bloc/bloc.dart";
import "package:test_news/features/news/domain/usecases/get_sources.dart";
import "source_event.dart";
import "source_state.dart";

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final GetSourcesByCategory getSourcesByCategory;
  String currentCategory = "";

  SourceBloc({required this.getSourcesByCategory}) : super(SourceInitial()) {
    on<LoadSources>(onLoadSources);
    on<LoadMoreSources>(onLoadMoreSources);
  }

  Future<void> onLoadSources(
    LoadSources event,
    Emitter<SourceState> emit,
  ) async {
    currentCategory = event.category;
    emit(SourceLoading());
    final result = await getSourcesByCategory(event.category);
    result.fold(
      (l) => emit(SourceError(message: l.message)),
      (r) => emit(
        SourceLoaded(
          sources: r,
          hasReachedMax: r.isEmpty,
        ),
      ),
    );
  }

  Future<void> onLoadMoreSources(
    LoadMoreSources event,
    Emitter<SourceState> emit,
  ) async {
    final currentState = state;
    if (currentState is SourceLoaded && !currentState.hasReachedMax) {
      final result = await getSourcesByCategory(currentCategory);
      result.fold(
        (l) => emit(SourceError(message: l.message)),
        (r) {
          if (r.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(
              SourceLoaded(
                sources: [...currentState.sources, ...r],
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    }
  }
}