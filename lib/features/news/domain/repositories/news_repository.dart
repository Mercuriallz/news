import "package:fpdart/fpdart.dart";
import "../../../../core/errors/failures.dart";
import "../entities/article.dart";
import "../entities/category.dart";
import "../entities/source.dart";

abstract class NewsRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Source>>> getSourcesByCategory(String category);
  Future<Either<Failure, List<Article>>> getArticlesBySource(String sourceId, int page);
  Future<Either<Failure, List<Article>>> searchArticles(String query, int page);
  Future<Either<Failure, List<Source>>> searchSources(String query);
}