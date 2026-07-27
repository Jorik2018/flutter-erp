import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class NetworkStatus {
  Future<bool> get isConnected;
}

class NetworkStatusImpl implements NetworkStatus {
  const NetworkStatusImpl(this._connectionChecker);

  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
