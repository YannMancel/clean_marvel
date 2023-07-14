import 'package:clean_marvel/core/_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// This class allows to manage the connection state.
///
/// ```dart
/// final connectionChecker = InternetConnectionChecker();
///
/// final networkData = NetworkData(connectionChecker: connectionChecker);
/// ```
class NetworkData implements NetworkDataInterface {
  const NetworkData({
    required InternetConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
