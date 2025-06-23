import "package:fpdart/fpdart.dart";
import "../../../../core/errors/failures.dart";
import "../entities/article.dart";
import "../entities/source.dart";
import "../repositories/news_repository.dart";

class SearchArticles {
  final NewsRepository repository;

  SearchArticles({required this.repository});

  Future<Either<Failure, List<Article>>> call(String query, int page) async {
    return await repository.searchArticles(query, page);
  }
}

class SearchSources {
  final NewsRepository repository;

  SearchSources(Object object, {required this.repository});

  Future<Either<Failure, List<Source>>> call(String query) async {
    return await repository.searchSources(query);
  }
}