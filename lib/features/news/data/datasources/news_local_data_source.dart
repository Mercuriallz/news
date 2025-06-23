import "package:fpdart/fpdart.dart";
import "../models/article_model.dart";
import "../models/category_model.dart";
import "../models/source_model.dart";

abstract class NewsLocalDataSource {
  Future<List<CategoryModel>> getLastCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<SourceModel>> getLastSources();
  Future<void> cacheSources(List<SourceModel> sources);
  Future<List<ArticleModel>> getLastArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  @override
  Future<void> cacheArticles(List<ArticleModel> articles) {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheSources(List<SourceModel> sources) {
    throw UnimplementedError();
  }

  @override
  Future<List<ArticleModel>> getLastArticles() {
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryModel>> getLastCategories() {
    throw UnimplementedError();
  }

  @override
  Future<List<SourceModel>> getLastSources() {
    throw UnimplementedError();
  }
}