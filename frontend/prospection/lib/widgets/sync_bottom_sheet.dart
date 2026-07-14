// lib/widgets/sync/sync_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:isetagcom/utils/sync_queue.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';

class SyncBottomSheet extends StatefulWidget {
  const SyncBottomSheet({super.key});

  @override
  State<SyncBottomSheet> createState() => _SyncBottomSheetState();
}

class _SyncBottomSheetState extends State<SyncBottomSheet> {
  final SyncQueue _syncQueue = SyncQueue();
  
  Map<String, int> _pendingItems = {};
  int _totalItems = 0;
  int _syncedItems = 0;
  bool _isSyncing = false;
  double _progress = 0.0;
  String _statusMessage = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPendingItems();
    _listenToSyncStatus();
  }

  void _listenToSyncStatus() {
    _syncQueue.queueStatusStream.listen((hasPending) {
      setState(() {
        _isSyncing = hasPending;
        if (!hasPending && _progress == 1.0) {
          _statusMessage = 'sync_completed'.tr;
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

  Future<void> _loadPendingItems() async {
    final items = await _syncQueue.getPendingItemsByType();
    setState(() {
      _pendingItems = items;
      _totalItems = items.values.fold(0, (sum, count) => sum + count);
      _syncedItems = 0;
      _statusMessage = _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
    });
  }

  Future<void> _refreshData() async {
    final items = await _syncQueue.getPendingItemsByType();
    setState(() {
      _pendingItems = items;
      _totalItems = items.values.fold(0, (sum, count) => sum + count);
      _syncedItems = (_progress * _totalItems).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              _buildStatusIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusTitle(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_statusMessage.isNotEmpty)
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              if (_isSyncing)
                TextButton(
                  onPressed: _cancelSync,
                  child: Text('cancel'.tr),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          if (_isSyncing || _progress > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    Text(
                      '$_syncedItems / $_totalItems',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Category progress list
          if (_pendingItems.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'sync_details'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 18),
                      onPressed: _refreshData,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._pendingItems.entries.map((entry) => _buildCategoryItem(
                      key: entry.key,
                      count: entry.value,
                      total: _totalItems,
                    )),
              ],
            ),

          const SizedBox(height: 16),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Action buttons
          if (!_isSyncing && _errorMessage != null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retrySync,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('sync_retry'.tr),
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (_isSyncing) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    } else if (_errorMessage != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      );
    } else if (_progress == 1.0 && _totalItems > 0) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    } else if (_totalItems == 0) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.cloud_done, color: Colors.grey, size: 20),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.cloud_queue, color: Colors.grey, size: 20),
      );
    }
  }

  String _getStatusTitle() {
    if (_isSyncing) return 'sync_in_progress'.tr;
    if (_errorMessage != null) return 'sync_failed'.tr;
    if (_progress == 1.0 && _totalItems > 0) return 'sync_completed'.tr;
    if (_totalItems == 0) return 'all_synced'.tr;
    return 'sync_status'.tr;
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDone ? AppColors.primaryGreen : Colors.grey.shade400,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDone ? AppColors.primaryGreen : Colors.grey.shade700,
                fontWeight: isDone ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 16)
          else
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'etablissements':
        return Icons.school_outlined;
      case 'sources':
        return Icons.source_outlined;
      case 'classes':
        return Icons.class_outlined;
      case 'specialites':
        return Icons.category_outlined;
      case 'fiches':
        return Icons.description_outlined;
      case 'prospects':
        return Icons.people_outline;
      case 'interets':
        return Icons.favorite_outline;
      default:
        return Icons.circle_outlined;
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

  void _cancelSync() {
    // TODO: Implement cancel sync logic
    print('Sync cancelled');
  }

  void _retrySync() {
    setState(() {
      _errorMessage = null;
    });
    _syncQueue.syncNow();
  }
}