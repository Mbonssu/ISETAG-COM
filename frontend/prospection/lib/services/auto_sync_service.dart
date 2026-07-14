// lib/services/auto_sync_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isetagcom/utils/sync_queue.dart';

class AutoSyncService {
  static final AutoSyncService _instance = AutoSyncService._internal();
  factory AutoSyncService() => _instance;
  AutoSyncService._internal();

  final SyncQueue _syncQueue = SyncQueue();
  final Connectivity _connectivity = Connectivity();
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  bool _isInitialized = false;
  Timer? _periodicSyncTimer;
  
  // ✅ Prevent multiple sync triggers
  bool _isSyncing = false;
  DateTime? _lastSyncAttempt;
  static const Duration _minSyncInterval = Duration(seconds: 30);

  Future<void> init() async {
    if (_isInitialized) return;

    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final isNowOnline = results.any((r) => r != ConnectivityResult.none);
        _onConnectivityChanged(isNowOnline);
      },
    );

    _isInitialized = true;

    if (_isOnline) {
      await _checkAndSync();
    }

    // ✅ Increase interval to 15 minutes
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => _checkAndSync(),
    );
  }

  void _onConnectivityChanged(bool isNowOnline) {
    if (isNowOnline && !_isOnline) {
      print('🌐 Connection restored! Checking for pending items...');
      _checkAndSync();
    }
    _isOnline = isNowOnline;
  }

  Future<void> _checkAndSync() async {
    // ✅ Prevent multiple sync attempts
    if (_isSyncing) {
      print('⏳ Sync already in progress, skipping...');
      return;
    }
    
    // ✅ Rate limit sync attempts
    if (_lastSyncAttempt != null) {
      final elapsed = DateTime.now().difference(_lastSyncAttempt!);
      if (elapsed < _minSyncInterval) {
        print('⏳ Last sync was ${elapsed.inSeconds}s ago, waiting...');
        return;
      }
    }

    // ✅ Check if there are pending items
    if (!await _syncQueue.hasPendingItems()) {
      print('✅ No pending items to sync');
      return;
    }

    // ✅ Start syncing
    print('🔄 Starting auto-sync...');
    _isSyncing = true;
    _lastSyncAttempt = DateTime.now();
    
    try {
      await _syncQueue.processPendingItems();
    } catch (e) {
      print('❌ Auto-sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> manualSync() async {
    if (!_isOnline) {
      throw Exception('No internet connection');
    }
    
    _lastSyncAttempt = DateTime.now();
    await _syncQueue.syncNow();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
  }

  bool get isOnline => _isOnline;
  bool get isSyncing => _syncQueue.isProcessing;
}