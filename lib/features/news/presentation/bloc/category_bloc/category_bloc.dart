import "package:bloc/bloc.dart";
import "package:test_news/features/news/domain/usecases/get_categories.dart";
import "category_event.dart";
import "category_state.dart";

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;

  CategoryBloc({required this.getCategories}) : super(CategoryInitial()) {
    on<LoadCategories>(onLoadCategories);
  }

  Future<void> onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await getCategories();
    result.fold(
      (l) => emit(CategoryError(message: l.message)),
      (r) => emit(CategoryLoaded(categories: r)),
    );
  }
}