import "package:fpdart/fpdart.dart";
import "../../../../core/errors/failures.dart";
import "../entities/article.dart";
import "../repositories/news_repository.dart";

class GetArticlesBySource {
  final NewsRepository repository;

  GetArticlesBySource({required this.repository});

  Future<Either<Failure, List<Article>>> call(String sourceId, int page) async {
    return await repository.getArticlesBySource(sourceId, page);
  }
}