import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_news/core/errors/exception.dart';
import '../models/article_model.dart';
import '../models/category_model.dart';
import '../models/source_model.dart';

abstract class NewsLocalDataSource {
  Future<List<CategoryModel>> getLastCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<SourceModel>> getLastSources();
  Future<void> cacheSources(List<SourceModel> sources);
  Future<List<ArticleModel>> getLastArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;

  NewsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final categoriesJson = categories.map((category) => jsonEncode({
        'name': category.name,
        'displayName': category.displayName,
      })).toList();
      
      await sharedPreferences.setStringList(
        'cached_categories',
        categoriesJson,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache categories: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getLastCategories() async {
    try {
      final categoriesJson = sharedPreferences.getStringList('cached_categories');
      if (categoriesJson == null || categoriesJson.isEmpty) {
        return [];
      }
      
      return categoriesJson.map((categoryJson) {
        final categoryMap = jsonDecode(categoryJson) as Map<String, dynamic>;
        return CategoryModel(
          name: categoryMap['name'] as String,
          displayName: categoryMap['displayName'] as String,
        );
      }).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached categories: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheSources(List<SourceModel> sources) async {
    try {
      final sourcesJson = sources.map((source) => jsonEncode({
        'id': source.id,
        'name': source.name,
        'description': source.description,
        'url': source.url,
        'category': source.category,
        'language': source.language,
        'country': source.country,
      })).toList();
      
      await sharedPreferences.setStringList(
        'cached_sources',
        sourcesJson,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache sources: ${e.toString()}');
    }
  }

  @override
  Future<List<SourceModel>> getLastSources() async {
    try {
      final sourcesJson = sharedPreferences.getStringList('cached_sources');
      if (sourcesJson == null || sourcesJson.isEmpty) {
        return [];
      }
      
      return sourcesJson.map((sourceJson) {
        final sourceMap = jsonDecode(sourceJson) as Map<String, dynamic>;
        return SourceModel(
          id: sourceMap['id'] as String,
          name: sourceMap['name'] as String,
          description: sourceMap['description'] as String,
          url: sourceMap['url'] as String,
          category: sourceMap['category'] as String,
          language: sourceMap['language'] as String,
          country: sourceMap['country'] as String,
        );
      }).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached sources: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    try {
      final articlesJson = articles.map((article) => jsonEncode({
        'source': {
          'id': article.source.id,
          'name': article.source.name,
        },
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'url': article.url,
        'urlToImage': article.urlToImage,
        'publishedAt': article.publishedAt.toIso8601String(),
        'content': article.content,
      })).toList();
      
      await sharedPreferences.setStringList(
        'cached_articles',
        articlesJson,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache articles: ${e.toString()}');
    }
  }

  @override
  Future<List<ArticleModel>> getLastArticles() async {
    try {
      final articlesJson = sharedPreferences.getStringList('cached_articles');
      if (articlesJson == null || articlesJson.isEmpty) {
        return [];
      }
      
      return articlesJson.map((articleJson) {
        final articleMap = jsonDecode(articleJson) as Map<String, dynamic>;
        return ArticleModel(
          source: SourceModel.fromJson(articleMap['source'] as Map<String, dynamic>),
          author: articleMap['author'] as String,
          title: articleMap['title'] as String,
          description: articleMap['description'] as String,
          url: articleMap['url'] as String,
          urlToImage: articleMap['urlToImage'] as String,
          publishedAt: DateTime.parse(articleMap['publishedAt'] as String),
          content: articleMap['content'] as String,
        );
      }).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached articles: ${e.toString()}');
    }
  }
}