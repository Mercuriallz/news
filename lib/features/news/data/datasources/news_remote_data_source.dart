import "package:test_news/core/constants/strings.dart";
import "package:test_news/core/errors/exception.dart";
import "../../../../core/network/api_client.dart";
import "../models/article_model.dart";
import "../models/category_model.dart";
import "../models/source_model.dart";

abstract class NewsRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<SourceModel>> getSourcesByCategory(String category);
  Future<List<ArticleModel>> getArticlesBySource(String sourceId, int page);
  Future<List<ArticleModel>> searchArticles(String query, int page);
  Future<List<SourceModel>> searchSources(String query);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient apiClient;
  final String apiKey;

  NewsRemoteDataSourceImpl({
    required this.apiClient,
    required this.apiKey,
  });

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categories = [
      CategoryModel(name: "business", displayName: AppStrings.business),
      CategoryModel(name: "entertainment", displayName: AppStrings.entertainment),
      CategoryModel(name: "general", displayName: AppStrings.general),
      CategoryModel(name: "health", displayName: AppStrings.health),
      CategoryModel(name: "science", displayName: AppStrings.science),
      CategoryModel(name: "sports", displayName: AppStrings.sports),
      CategoryModel(name: "technology", displayName: AppStrings.technology),
    ];
    return categories;
  }

  @override
  Future<List<SourceModel>> getSourcesByCategory(String category) async {
    final result = await apiClient.get(
      "https://newsapi.org/v2/top-headlines/sources",
      queryParameters: {
        "category": category,
        "apiKey": apiKey,
      },
    );

    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        final sources = data["sources"] as List?;
        if (sources == null) {
          throw ServerException(message: "Invalid sources data");
        }
        return sources.map((source) => SourceModel.fromJson(source)).toList();
      },
    );
  }

  @override
  Future<List<ArticleModel>> getArticlesBySource(String sourceId, int page) async {
    final result = await apiClient.get(
      "https://newsapi.org/v2/top-headlines",
      queryParameters: {
        "sources": sourceId,
        "page": page,
        "pageSize": 20,
        "apiKey": apiKey,
      },
    );

    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        final articles = data["articles"] as List?;
        if (articles == null) {
          throw ServerException(message: "Invalid articles data");
        }
        return articles.map((article) => ArticleModel.fromJson(article)).toList();
      },
    );
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query, int page) async {
    final result = await apiClient.get(
      "https://newsapi.org/v2/everything",
      queryParameters: {
        "q": query,
        "page": page,
        "pageSize": 20,
        "apiKey": apiKey,
      },
    );

    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        final articles = data["articles"] as List?;
        if (articles == null) {
          throw ServerException(message: "Invalid articles data");
        }
        return articles.map((article) => ArticleModel.fromJson(article)).toList();
      },
    );
  }

  @override
  Future<List<SourceModel>> searchSources(String query) async {
    final result = await apiClient.get(
      "https://newsapi.org/v2/top-headlines/sources",
      queryParameters: {
        "q": query,
        "apiKey": apiKey,
      },
    );

    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        final sources = data["sources"] as List?;
        if (sources == null) {
          throw ServerException(message: "Invalid sources data");
        }
        return sources.map((source) => SourceModel.fromJson(source)).toList();
      },
    );
  }
}