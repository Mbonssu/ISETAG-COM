// lib/utils/connection_checker.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
import 'package:isetagcom/services/api_service.dart';

class ConnectionChecker {
  static final ConnectionChecker _instance = ConnectionChecker._internal();
  factory ConnectionChecker() => _instance;
  ConnectionChecker._internal();

  final Connectivity _connectivity = Connectivity();
  final ApiService _api = ApiService();
  
  bool _hasConnection = false;
  bool _isApiReachable = false;
  
  // Stream for connection status changes
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;
  
  // Stream for API reachability changes
  final _apiReachableController = StreamController<bool>.broadcast();
  Stream<bool> get apiReachableStream => _apiReachableController.stream;

  // Getters
  bool get hasConnection => _hasConnection;
  bool get isApiReachable => _isApiReachable;
  bool get isConnected => _hasConnection && _isApiReachable;

  // Initialize the checker
  Future<void> init() async {
    // Check initial connection
    await _checkConnection();
    
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      _checkConnection();
    });
  }

  // Check connection status
  Future<void> _checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final bool wasConnected = _hasConnection;
      final bool wasApiReachable = _isApiReachable;
      
      // Check if any connection exists
      _hasConnection = results.any((r) => r != ConnectivityResult.none);
      
      // If we have connection, check API
      if (_hasConnection) {
        _isApiReachable = await _checkApiHealth();
      } else {
        _isApiReachable = false;
      }
      
      // Notify listeners if status changed
      if (wasConnected != _hasConnection) {
        _connectionController.add(_hasConnection);
      }
      
      if (wasApiReachable != _isApiReachable) {
        _apiReachableController.add(_isApiReachable);
      }
      
      print('🌐 Connection: ${_hasConnection ? 'ONLINE' : 'OFFLINE'}');
      print('📡 API: ${_isApiReachable ? 'REACHABLE' : 'NOT REACHABLE'}');
      
    } catch (e) {
      print(' Connection check error: $e');
      _hasConnection = false;
      _isApiReachable = false;
    }
  }

  // Check if API is reachable
  Future<bool> _checkApiHealth() async {
    try {
      final result = await _api.healthCheck();
      return result['success'] == true;
    } catch (e) {
      print(' API health check failed: $e');
      return false;
    }
  }

  // Quick check for internet connection
  Future<bool> hasInternet() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  // Quick check for API reachability
  Future<bool> isApiCanBeReached() async {
    if (!await hasInternet()) return false;
    return await _checkApiHealth();
  }

  // Check both connection and API
  Future<bool> isFullyConnected() async {
    if (!await hasInternet()) return false;
    return await isApiCanBeReached();
  }

  // Dispose
  void dispose() {
    _connectionController.close();
    _apiReachableController.close();
  }
}