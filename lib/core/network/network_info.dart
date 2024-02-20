import 'package:internet_connection_checker/internet_connection_checker.dart';

/// **Responsibility**: Manage the connection state.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoByInternetConnectionChecker implements NetworkInfo {
  const NetworkInfoByInternetConnectionChecker({
    required InternetConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
