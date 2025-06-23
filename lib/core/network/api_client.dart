import "package:dio/dio.dart";
import "package:fpdart/fpdart.dart";
import "../../core/errors/failures.dart";

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio});

  Future<Either<Failure, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}