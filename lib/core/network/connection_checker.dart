import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
  Future<bool> get isDisconnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;

  ConnectionCheckerImpl(this.internetConnection);
  @override
  Future<bool> get isConnected async => await internetConnection.hasInternetAccess;

  @override
  Future<bool> get isDisconnected async => !(await internetConnection.hasInternetAccess);
}
