import "package:fpdart/fpdart.dart";
import "../../../../core/errors/failures.dart";
import "../entities/source.dart";
import "../repositories/news_repository.dart";

class GetSourcesByCategory {
  final NewsRepository repository;

  GetSourcesByCategory({required this.repository});

  Future<Either<Failure, List<Source>>> call(String category) async {
    return await repository.getSourcesByCategory(category);
  }
}