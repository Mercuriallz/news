import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo({required this.connectivity});

  Future<Either<Failure, bool>> get isConnected async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await connectivity.checkConnectivity();
      final bool isConnected = connectivityResult.isNotEmpty &&
          connectivityResult.any(
            (result) => result != ConnectivityResult.none,
          );

      return Right(isConnected);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
