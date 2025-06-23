import "package:fpdart/fpdart.dart";
import "../../../../core/errors/failures.dart";
import "../entities/category.dart";
import "../repositories/news_repository.dart";

class GetCategories {
  final NewsRepository repository;

  GetCategories({required this.repository});

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}