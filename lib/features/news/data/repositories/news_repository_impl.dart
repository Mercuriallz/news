import "package:fpdart/fpdart.dart";
import "package:test_news/core/errors/exception.dart";
import "../../../../core/errors/failures.dart";
import "../../../../core/network/network_info.dart";
import "../../domain/entities/article.dart";
import "../../domain/entities/category.dart";
import "../../domain/entities/source.dart";
import "../../domain/repositories/news_repository.dart";
import "../datasources/news_local_data_source.dart";
import "../datasources/news_remote_data_source.dart";

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final isConnected = await networkInfo.isConnected;
    return await isConnected.fold(
      (failure) => Left(failure),
      (connected) async {
        if (connected) {
          try {
            final remoteCategories = await remoteDataSource.getCategories();
            await localDataSource.cacheCategories(remoteCategories);
            return Right(remoteCategories.map((e) => e.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        } else {
          try {
            final localCategories = await localDataSource.getLastCategories();
            return Right(localCategories.map((e) => e.toEntity()).toList());
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<Source>>> getSourcesByCategory(String category) async {
    final isConnected = await networkInfo.isConnected;
    return await isConnected.fold(
      (failure) => Left(failure),
      (connected) async {
        if (connected) {
          try {
            final remoteSources = await remoteDataSource.getSourcesByCategory(category);
            await localDataSource.cacheSources(remoteSources);
            return Right(remoteSources.map((e) => e.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        } else {
          try {
            final localSources = await localDataSource.getLastSources();
            return Right(localSources.map((e) => e.toEntity()).toList());
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesBySource(String sourceId, int page) async {
    final isConnected = await networkInfo.isConnected;
    return await isConnected.fold(
      (failure) => Left(failure),
      (connected) async {
        if (connected) {
          try {
            final remoteArticles = await remoteDataSource.getArticlesBySource(sourceId, page);
            if (page == 1) {
              await localDataSource.cacheArticles(remoteArticles);
            }
            return Right(remoteArticles.map((e) => e.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        } else {
          try {
            final localArticles = await localDataSource.getLastArticles();
            return Right(localArticles.map((e) => e.toEntity()).toList());
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<Article>>> searchArticles(String query, int page) async {
    final isConnected = await networkInfo.isConnected;
    return await isConnected.fold(
      (failure) => Left(failure),
      (connected) async {
        if (connected) {
          try {
            final remoteArticles = await remoteDataSource.searchArticles(query, page);
            if (page == 1) {
              await localDataSource.cacheArticles(remoteArticles);
            }
            return Right(remoteArticles.map((e) => e.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        } else {
          try {
            final localArticles = await localDataSource.getLastArticles();
            return Right(localArticles.map((e) => e.toEntity()).toList());
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<Source>>> searchSources(String query) async {
    final isConnected = await networkInfo.isConnected;
    return await isConnected.fold(
      (failure) => Left(failure),
      (connected) async {
        if (connected) {
          try {
            final remoteSources = await remoteDataSource.searchSources(query);
            await localDataSource.cacheSources(remoteSources);
            return Right(remoteSources.map((e) => e.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        } else {
          try {
            final localSources = await localDataSource.getLastSources();
            return Right(localSources.map((e) => e.toEntity()).toList());
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          }
        }
      },
    );
  }
}