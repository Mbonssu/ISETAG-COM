// lib/screens/sync_screen.dart
// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:isetagcom/utils/sync_queue.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';
import 'package:isetagcom/services/auto_sync_service.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncQueue _syncQueue = SyncQueue();
  final AutoSyncService _autoSync = AutoSyncService();

  Map<String, int> _pendingItems = {};
  int _totalItems = 0;
  int _syncedItems = 0;
  double _progress = 0.0;
  bool _isSyncing = false;
  String _statusMessage = '';
  String? _errorMessage;

  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _listenToSyncUpdates();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _refreshData();
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);

    final items = await _syncQueue.getPendingItemsByType();
    final total = items.values.fold(0, (sum, count) => sum + count);

    setState(() {
      _pendingItems = items;
      _totalItems = total;
      _isSyncing = _syncQueue.isProcessing;
      _syncedItems = (_progress * total).toInt();
      _statusMessage =
          _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
      _isRefreshing = false;
    });
  }

  void _listenToSyncUpdates() {
    _syncQueue.queueStatusStream.listen((isProcessing) {
      setState(() {
        _isSyncing = isProcessing;
        if (isProcessing) {
          _statusMessage = 'sync_in_progress'.tr;
        } else if (_errorMessage == null) {
          _statusMessage = 'sync_status_idle'.tr;
        }
      });
    });

    _syncQueue.progressStream.listen((progress) {
      setState(() {
        _progress = progress;
        _syncedItems = (_progress * _totalItems).toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text('sync_status'.tr),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppColors.primaryGreen,
              child: _totalItems == 0
                  ? _buildEmptyState()
                  : SingleChildScrollView(
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
                              _buildSummaryCard(),
                              const SizedBox(height: 20),
                              _buildProgressSection(),
                              const SizedBox(height: 20),
                              _buildPendingItemsList(),
                              const SizedBox(height: 20),
                              _buildActionButtons(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }

  // Empty State Widget - Full Screen Centered
  Widget _buildEmptyState() {
    return Column(
      children: [
        // ✅ Connection Status at the top
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildConnectionStatus(),
        ),
        // ✅ Empty state content centered
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated icon
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade100,
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.cloud_done_rounded,
                      size: 80,
                      color: Colors.green.shade500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'no_data_to_sync'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'all_data_synced'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'all_up_to_date'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Refresh button
                  OutlinedButton.icon(
                    onPressed: _refreshData,
                    icon: _isRefreshing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryGreen),
                            ),
                          )
                        : const Icon(Icons.refresh_rounded),
                    label: Text(_isRefreshing ? 'refreshing'.tr : 'refresh'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(
                          color: AppColors.primaryGreen.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    final isOnline = _syncQueue.isConnected;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOnline ? Colors.green.shade200 : Colors.red.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isOnline ? 'connection_online'.tr : 'connection_offline'.tr,
              style: TextStyle(
                color: isOnline ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (isOnline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'online'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.cloud_queue_rounded,
                  label: 'total_pending'.tr,
                  value: '$_totalItems',
                  color: Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.check_circle_rounded,
                  label: 'synced'.tr,
                  value: '$_syncedItems',
                  color: Colors.green,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.pending_rounded,
                  label: 'remaining'.tr,
                  value: '${_totalItems - _syncedItems}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          if (_isSyncing) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'sync_in_progress'.tr,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title and Percentage - Fixed with Flexible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  'sync_progress'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: (_isSyncing ? Colors.blue : Colors.green)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(_progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _isSyncing ? Colors.blue : Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isSyncing ? Colors.blue : Colors.green,
                ),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Row 3: Count and Status - Fixed with Flexible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  '${_syncedItems} / $_totalItems',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 13,
                    color: _isSyncing ? Colors.blue : Colors.grey.shade600,
                    fontWeight:
                        _isSyncing ? FontWeight.w600 : FontWeight.normal,
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

  Widget _buildPendingItemsList() {
    final items = _pendingItems.entries.toList();
    final total = _pendingItems.values.fold(0, (sum, count) => sum + count);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'pending_items'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_totalItems',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 24, color: Colors.grey.shade100),
          ...items.map((entry) => _buildCategoryItem(
                key: entry.key,
                count: entry.value,
                total: total,
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String key,
    required int count,
    required int total,
  }) {
    final icon = _getCategoryIcon(key);
    final label = _getCategoryLabel(key);
    final isDone = count == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isDone ? FontWeight.w600 : FontWeight.w500,
                  color: isDone ? Colors.green.shade700 : Colors.grey.shade700,
                ),
              ),
            ),
            if (isDone)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Synced',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade700,
                  ),
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
      default:
        return key;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSyncing ? null : _startSync,
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
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isRefreshing ? null : _refreshData,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('refresh'.tr),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startSync() async {
    if (!_syncQueue.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('no_connection'.tr),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    try {
      await _syncQueue.syncNow();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('sync_error'.tr.replaceFirst('{error}', e.toString())),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
