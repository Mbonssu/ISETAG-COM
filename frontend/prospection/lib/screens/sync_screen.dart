// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isetagcom/utils/sync_queue.dart';
import 'package:isetagcom/utils/connection_checker.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncQueue _syncQueue = SyncQueue();
  final ConnectionChecker _connection = ConnectionChecker();

  Map<String, int> _pendingByType = {};
  Map<String, int> _updateByType = {};
  int _pendingTotal = 0;
  int _updateTotal = 0;
  int _failedTotal = 0;
  int _syncedTotal = 0;

  double _progress = 0.0;
  bool _isSyncing = false;
  bool _isPaused = false;
  bool _hasNetwork = false;
  bool _isApiReachable = false;
  String _statusMessage = '';
  
  // ✅ NEW: Track sync interruption and last error
  bool _isSyncInterrupted = false;
  String? _lastError;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isRetryingFailed = false;
  bool _isCheckingConnection = false;

  int _selectedBatchSize = 10;
  static const List<int> _batchSizeOptions = [5, 10, 25];

  StreamSubscription<bool>? _queueStatusSub;
  StreamSubscription<double>? _progressSub;
  StreamSubscription<bool>? _networkSub;
  StreamSubscription<bool>? _apiReachableSub;
  StreamSubscription<bool>? _pauseStatusSub;
  StreamSubscription<SyncEvent>? _syncEventSub;

  @override
  void initState() {
    super.initState();
    _selectedBatchSize = _syncQueue.batchSize;
    _loadLocalDataOnly();
    _listenToSyncUpdates();

    _hasNetwork = _connection.hasNetwork;
    _isApiReachable = _connection.isApiReachable;
    _isSyncInterrupted = false;
  }

  @override
  void dispose() {
    _queueStatusSub?.cancel();
    _progressSub?.cancel();
    _networkSub?.cancel();
    _apiReachableSub?.cancel();
    _pauseStatusSub?.cancel();
    _syncEventSub?.cancel();
    super.dispose();
  }

  // ✅ Load local data only (no API calls on init)
  Future<void> _loadLocalDataOnly() async {
    setState(() => _isLoading = true);

    final pending = await _syncQueue.getPendingItemsByType();
    final updates = await _syncQueue.getUpdateItemsByType();
    final failed = await _syncQueue.getFailedCount();
    final synced = await _syncQueue.getSyncedCount();
    final pendingTotal = pending.values.fold(0, (sum, count) => sum + count);
    final updateTotal = updates.values.fold(0, (sum, count) => sum + count);

    setState(() {
      _pendingByType = pending;
      _updateByType = updates;
      _pendingTotal = pendingTotal;
      _updateTotal = updateTotal;
      _failedTotal = failed;
      _syncedTotal = synced;
      _isSyncing = _syncQueue.isProcessing;
      _isPaused = _syncQueue.isPaused;
      _statusMessage =
          _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
      _isLoading = false;
    });
  }

  // ✅ Refresh with connection check
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    setState(() => _isCheckingConnection = true);
    await _connection.refresh();
    setState(() => _isCheckingConnection = false);

    await _refreshData();
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);

    final pending = await _syncQueue.getPendingItemsByType();
    final updates = await _syncQueue.getUpdateItemsByType();
    final failed = await _syncQueue.getFailedCount();
    final synced = await _syncQueue.getSyncedCount();
    final pendingTotal = pending.values.fold(0, (sum, count) => sum + count);
    final updateTotal = updates.values.fold(0, (sum, count) => sum + count);

    setState(() {
      _pendingByType = pending;
      _updateByType = updates;
      _pendingTotal = pendingTotal;
      _updateTotal = updateTotal;
      _failedTotal = failed;
      _syncedTotal = synced;
      _isSyncing = _syncQueue.isProcessing;
      _isPaused = _syncQueue.isPaused;
      _hasNetwork = _connection.hasNetwork;
      _isApiReachable = _connection.isApiReachable;
      _statusMessage =
          _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
      _isRefreshing = false;

      // ✅ Clear interruption flag when sync completes successfully
      if (!_isSyncing && _pendingTotal == 0 && _updateTotal == 0) {
        _isSyncInterrupted = false;
        _lastError = null;
      }
    });
  }

  void _listenToSyncUpdates() {
    // ✅ Listen to sync status changes
    _queueStatusSub = _syncQueue.queueStatusStream.listen((isProcessing) {
      setState(() {
        _isSyncing = isProcessing;
        if (isProcessing && !_isSyncInterrupted) {
          _statusMessage = 'sync_in_progress'.tr;
        } else if (!isProcessing && !_isSyncInterrupted) {
          _statusMessage = 'sync_status_idle'.tr;
        }
      });
      if (!isProcessing && !_isSyncInterrupted) {
        _refreshData();
      }
    });

    // ✅ Listen to progress updates
    _progressSub = _syncQueue.progressStream.listen((progress) {
      setState(() => _progress = progress);
    });

    // ✅ Listen to network status changes
    _networkSub = _connection.connectionStream.listen((hasNetwork) {
      setState(() => _hasNetwork = hasNetwork);
      
      // ✅ If network is lost during sync, mark as interrupted
      if (!hasNetwork && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'network_lost';
        setState(() {
          _statusMessage = 'connection_lost_during_sync'.tr;
        });
      }
      
      // ✅ If network restored and sync was interrupted, show resume button
      if (hasNetwork && _isSyncInterrupted && _isSyncing) {
        setState(() {
          _statusMessage = 'connection_restored_click_resume'.tr;
        });
      }
    });

    // ✅ Listen to API reachability
    _apiReachableSub = _connection.apiReachableStream.listen((reachable) {
      setState(() => _isApiReachable = reachable);
      
      if (!reachable && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'server_unreachable';
        setState(() {
          _statusMessage = 'server_unreachable'.tr;
        });
      }
      
      if (reachable && _isSyncInterrupted && _isSyncing) {
        setState(() {
          _statusMessage = 'connection_restored_click_resume'.tr;
        });
      }
    });

    // ✅ Listen to pause status
    _pauseStatusSub = _syncQueue.pauseStatusStream.listen((isPaused) {
      setState(() => _isPaused = isPaused);
      if (isPaused && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'paused';
        setState(() {
          _statusMessage = 'sync_paused'.tr;
        });
      }
    });

    // ✅ Listen to sync events (errors, completion)
    _syncEventSub = _syncQueue.syncEventStream.listen((event) {
      if (event.type == SyncEventType.error) {
        _isSyncInterrupted = true;
        _lastError = event.message ?? 'unknown_error';
        setState(() {
          _statusMessage = event.message ?? 'sync_error'.tr;
        });
      } else if (event.type == SyncEventType.completed) {
        _isSyncInterrupted = false;
        _lastError = null;
        _refreshData();
      }
    });
  }

  bool get _isFullyConnected => _hasNetwork && _isApiReachable;
  bool get _hasDataToSync =>
      _pendingTotal > 0 || _failedTotal > 0 || _updateTotal > 0;
  
  // ✅ NEW: Show resume button if sync was interrupted
  bool get _showResumeButton =>
      _isSyncInterrupted &&
      (_pendingTotal > 0 || _failedTotal > 0 || _updateTotal > 0);

  @override
  Widget build(BuildContext context) {
    final bool isAllSynced = !_isLoading &&
        _pendingTotal == 0 &&
        _updateTotal == 0 &&
        _failedTotal == 0 &&
        !_isSyncing &&
        !_isCheckingConnection &&
        !_isSyncInterrupted;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text('sync_status'.tr),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isRefreshing || _isCheckingConnection
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed:
                (_isRefreshing || _isCheckingConnection) ? null : _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: isAllSynced
                  ? _buildGoldenIconWithText()
                  : _buildSyncContent(),
            ),
    );
  }

  Widget _buildGoldenIconWithText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD700),
                Color(0xFFFFA500),
                Color(0xFFFFD700),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.cloud_done_rounded,
            color: Colors.white,
            size: 80,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'all_synced'.tr,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7A5C00),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'all_data_synced_successfully'.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.brown.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Text(
            '${_syncedTotal} ${'items_synced'.tr}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primaryGreen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConnectionStatus(),
                const SizedBox(height: 20),
                _buildStatsGrid(),
                const SizedBox(height: 20),
                if (_isSyncing ||
                    _pendingTotal > 0 ||
                    _updateTotal > 0 ||
                    _isSyncInterrupted) ...[
                  _buildProgressSection(),
                  const SizedBox(height: 20),
                ],
                // ✅ Show interrupted banner if sync was interrupted
                if (_isSyncInterrupted) ...[
                  _buildInterruptedBanner(),
                  const SizedBox(height: 20),
                ],
                if (_failedTotal > 0) ...[
                  _buildFailedBanner(),
                  const SizedBox(height: 20),
                ],
                _buildBatchSizeSelector(),
                const SizedBox(height: 20),
                if (_pendingTotal > 0 || _updateTotal > 0) ...[
                  _buildPendingItemsList(),
                  const SizedBox(height: 20),
                ],
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    final Color color;
    final IconData icon;
    final String label;

    if (!_hasNetwork) {
      color = Colors.red;
      icon = Icons.wifi_off_rounded;
      label = 'connection_offline'.tr;
    } else if (!_isApiReachable) {
      color = Colors.orange;
      icon = Icons.cloud_off_rounded;
      label = 'connected_no_server'.tr;
    } else {
      color = Colors.green;
      icon = Icons.wifi_rounded;
      label = 'connection_online'.tr;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                if (_isFullyConnected)
                  Text(
                    'Via ${_connection.activeResourceLabel}',
                    style: TextStyle(
                        color: color.withOpacity(0.8), fontSize: 11.5),
                  ),
                // ✅ Show interruption reason
                if (_isSyncInterrupted)
                  Text(
                    _lastError == 'network_lost'
                        ? 'connection_lost_during_sync'.tr
                        : _lastError == 'server_unreachable'
                            ? 'server_unreachable'.tr
                            : 'sync_interrupted'.tr,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (_isFullyConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'online'.tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final hasUpdates = _updateTotal > 0;
    final hasFailed = _failedTotal > 0;
    final totalItems = _pendingTotal + _updateTotal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _statTile(
                  icon: Icons.cloud_queue_rounded,
                  label: 'total_pending'.tr,
                  value: '$totalItems',
                  color: AppColors.statBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _statTile(
                  icon: Icons.update_rounded,
                  label: 'to_update'.tr,
                  value: '$_updateTotal',
                  color: hasUpdates ? Colors.orange : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _statTile(
                  icon: Icons.check_circle_rounded,
                  label: 'synced'.tr,
                  value: '$_syncedTotal',
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _statTile(
                  icon: Icons.error_outline_rounded,
                  label: 'failed'.tr,
                  value: '$_failedTotal',
                  color: hasFailed ? AppColors.badgeOrange : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final remaining = _pendingTotal + _updateTotal;
    final totalThisRun = _syncQueue.totalItemsThisRun > 0
        ? _syncQueue.totalItemsThisRun
        : _pendingTotal + _updateTotal;

    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'sync_progress'.tr,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: (_isSyncing ? AppColors.statBlue : AppColors.primaryGreen)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _isSyncing ? AppColors.statBlue : AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                _isSyncing ? AppColors.statBlue : AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$remaining ${'remaining_to_sync'.tr} / $totalThisRun',
                  style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: _isSyncing ? AppColors.statBlue : Colors.grey.shade600,
                    fontWeight: _isSyncing ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Show interruption banner
  Widget _buildInterruptedBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'sync_interrupted'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _lastError == 'network_lost'
                ? 'connection_lost_will_pause_resume_when_restored'.tr
                : _lastError == 'server_unreachable'
                    ? 'server_unreachable_will_retry'.tr
                    : 'sync_interrupted_reason_unknown'.tr,
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.badgeOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.badgeOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.badgeOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$_failedTotal ${'items_failed_to_sync'.tr}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: _isRetryingFailed ? null : _retryFailed,
            child: _isRetryingFailed
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('retry'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchSizeSelector() {
    return _cardShell(
      child: Row(
        children: [
          const Icon(Icons.dns_outlined, color: AppColors.primaryGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text('batch_size'.tr,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          ),
          ..._batchSizeOptions.map((size) {
            final selected = size == _selectedBatchSize;
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: ChoiceChip(
                label: Text('$size'),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedBatchSize = size);
                  _syncQueue.setBatchSize(size);
                },
                selectedColor: AppColors.primaryGreen,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.grey.shade100,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPendingItemsList() {
    final items = {
      ..._pendingByType,
      ..._updateByType,
    };
    final displayItems = items.entries
        .where((e) => e.value > 0)
        .toList()
        .cast<MapEntry<String, int>>();

    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'pending_items'.tr,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '${_pendingTotal + _updateTotal}',
                  style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Divider(height: 24, color: Colors.grey.shade100),
          if (displayItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('no_data_to_sync'.tr,
                  style: TextStyle(color: Colors.grey.shade500)),
            )
          else
            ...displayItems.map((entry) =>
                _buildCategoryItem(key: entry.key, count: entry.value)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({required String key, required int count}) {
    final icon = _getCategoryIcon(key);
    final label = _getCategoryLabel(key);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration:
            BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  const BoxDecoration(color: AppColors.statBlue, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                '$count',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'etablissements':
        return Icons.school_rounded;
      case 'sources':
        return Icons.source_rounded;
      case 'classes':
        return Icons.class_rounded;
      case 'specialites':
        return Icons.category_rounded;
      case 'fiches':
        return Icons.description_rounded;
      case 'prospects':
        return Icons.people_rounded;
      case 'interets':
        return Icons.favorite_rounded;
      case 'relances':
        return Icons.repeat_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  String _getCategoryLabel(String key) {
    switch (key) {
      case 'etablissements':
        return 'establishments'.tr;
      case 'sources':
        return 'sources'.tr;
      case 'classes':
        return 'classes'.tr;
      case 'specialites':
        return 'specialties'.tr;
      case 'fiches':
        return 'fiches'.tr;
      case 'prospects':
        return 'prospects'.tr;
      case 'interets':
        return 'interests'.tr;
      case 'relances':
        return 'follow_ups'.tr;
      default:
        return key;
    }
  }

  Widget _buildActionButtons() {
    final bool hasDataToSync = _pendingTotal > 0 || _failedTotal > 0 || _updateTotal > 0;
    final bool isButtonEnabled = hasDataToSync && !_isSyncing;

    return Row(
      children: [
        // ✅ Main sync button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isButtonEnabled ? _startSync : null,
            icon: _isSyncing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sync_rounded),
            label: Text(_isSyncing ? 'syncing'.tr : 'sync_now'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isButtonEnabled ? AppColors.primaryGreen : Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        // ✅ Resume button (shown when sync is interrupted and connection restored)
        if (_showResumeButton) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _resumeSync,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('resume'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ] else
          // ✅ Refresh button (when not interrupted)
          ...[
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isRefreshing ? null : _loadData,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('refresh'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side:
                      BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
                ),
              ),
            ),
          ],
      ],
    );
  }

  Widget _cardShell({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  Future<void> _startSync() async {
    if (!_hasDataToSync) {
      _showSnack('nothing_to_sync'.tr, Colors.orange);
      return;
    }

    if (!_isFullyConnected) {
      _showSnack(
        _hasNetwork ? 'connected_no_server'.tr : 'no_connection'.tr,
        Colors.red,
      );
      return;
    }

    try {
      await _syncQueue.syncNow();
    } catch (e) {
      _showSnack(
          'sync_error'.tr.replaceFirst('{error}', e.toString()), Colors.red);
    }
  }

  // ✅ NEW: Resume sync after interruption
  Future<void> _resumeSync() async {
    if (!_isFullyConnected) {
      _showSnack(
        _hasNetwork ? 'connected_no_server'.tr : 'no_connection'.tr,
        Colors.red,
      );
      return;
    }

    setState(() {
      _isSyncInterrupted = false;
      _lastError = null;
      _statusMessage = 'resuming_sync'.tr;
    });

    try {
      await _syncQueue.resumeSync();
    } catch (e) {
      _showSnack('resume_error'.tr.replaceFirst('{error}', e.toString()),
          Colors.red);
    }
  }

  Future<void> _retryFailed() async {
    setState(() => _isRetryingFailed = true);
    try {
      await _syncQueue.retryFailedItems();
      await _refreshData();
    } finally {
      if (mounted) setState(() => _isRetryingFailed = false);
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
