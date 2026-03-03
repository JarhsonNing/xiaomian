import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final Connectivity _connectivity = Connectivity();
  late StreamController<bool> _networkStatusController;

  NetworkService._internal() {
    _networkStatusController = StreamController<bool>.broadcast();
    _initConnectivity();
  }

  Stream<bool> get onNetworkStatusChanged => _networkStatusController.stream;

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    bool isConnected = results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
    _networkStatusController.add(isConnected);
  }

  Future<bool> get isConnected async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
  }

  void dispose() {
    _networkStatusController.close();
  }
}
