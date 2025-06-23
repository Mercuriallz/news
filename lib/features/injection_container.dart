import "package:connectivity_plus/connectivity_plus.dart";
import "package:dio/dio.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:test_news/core/network/api_client.dart";
import "package:test_news/core/network/network_info.dart";
import "package:test_news/features/news/data/datasources/news_local_data_source.dart";
import "package:test_news/features/news/data/datasources/news_remote_data_source.dart";
import "package:test_news/features/news/data/repositories/news_repository_impl.dart";
import "package:test_news/features/news/domain/repositories/news_repository.dart";
import "package:test_news/features/news/domain/usecases/get_articles.dart";
import "package:test_news/features/news/domain/usecases/get_categories.dart";
import "package:test_news/features/news/domain/usecases/get_sources.dart";
import "package:test_news/features/news/domain/usecases/search_news.dart";
import "package:test_news/features/news/presentation/bloc/article_bloc/article_bloc.dart";
import "package:test_news/features/news/presentation/bloc/category_bloc/category_bloc.dart";
import "package:test_news/features/news/presentation/bloc/search_bloc/search_bloc.dart";
import "package:test_news/features/news/presentation/bloc/source_bloc/source_bloc.dart";

final sl = GetIt.instance;

Future<void> init() async {
  // sl.registerLazySingleton();

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerFactory(
    () => CategoryBloc(getCategories: sl()),
  );
  sl.registerFactory(
    () => SourceBloc(getSourcesByCategory: sl()),
  );
  sl.registerFactory(
    () => ArticleBloc(getArticlesBySource: sl()),
  );
  sl.registerFactory(
    () => SearchBloc(
      searchArticles: sl(),
      searchSources: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCategories(repository: sl()));
  sl.registerLazySingleton(() => GetSourcesByCategory(repository: sl()));
  sl.registerLazySingleton(() => GetArticlesBySource(repository: sl()));
  sl.registerLazySingleton(() => SearchArticles(repository: sl()));
  // sl.registerLazySingleton(() => SearchSources( repository: sl()));

  sl.registerLazySingleton(() => SearchSources(sl(), repository: sl()));

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(
      apiClient: sl(),
      apiKey: "c756cda5ff5c4768afbe4778e2921449",
    ),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(connectivity: sl()),
  );

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
