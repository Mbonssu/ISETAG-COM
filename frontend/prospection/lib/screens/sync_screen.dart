// // ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use, use_build_context_synchronously
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:isetagcom/utils/sync_queue.dart';
// import 'package:isetagcom/utils/connection_checker.dart';
// import 'package:isetagcom/services/translation_service.dart';
// import 'package:isetagcom/utils/themes/app_colors.dart';

// class SyncScreen extends StatefulWidget {
//   const SyncScreen({super.key});

//   @override
//   State<SyncScreen> createState() => _SyncScreenState();
// }

// class _SyncScreenState extends State<SyncScreen> {
//   final SyncQueue _syncQueue = SyncQueue();
//   final ConnectionChecker _connection = ConnectionChecker();

//   Map<String, int> _pendingByType = {};
//   int _pendingTotal = 0;
//   int _failedTotal = 0;
//   int _syncedTotal = 0;

//   double _progress = 0.0;
//   bool _isSyncing = false;
//   bool _isPaused = false;
//   bool _hasNetwork = false;
//   bool _isApiReachable = false;
//   String _statusMessage = '';

//   bool _isLoading = true;
//   bool _isRefreshing = false;
//   bool _isRetryingFailed = false;
//   bool _isCheckingConnection = false;

//   int _selectedBatchSize = 10;
//   static const List<int> _batchSizeOptions = [5, 10, 25];

//   StreamSubscription<bool>? _queueStatusSub;
//   StreamSubscription<double>? _progressSub;
//   StreamSubscription<bool>? _networkSub;
//   StreamSubscription<bool>? _apiReachableSub;
//   StreamSubscription<bool>? _pauseStatusSub;

//   @override
//   void initState() {
//     super.initState();
//     _selectedBatchSize = _syncQueue.batchSize;
//     // ✅ NE PAS appeler _loadData() ici - on charge seulement les données locales
//     _loadLocalDataOnly();
//     _listenToSyncUpdates();
//   }

//   @override
//   void dispose() {
//     _queueStatusSub?.cancel();
//     _progressSub?.cancel();
//     _networkSub?.cancel();
//     _apiReachableSub?.cancel();
//     _pauseStatusSub?.cancel();
//     super.dispose();
//   }

//   // ✅ NOUVELLE MÉTHODE : Charge uniquement les données locales SANS appeler l'API
//   Future<void> _loadLocalDataOnly() async {
//     setState(() => _isLoading = true);

//     // ✅ Récupérer les données locales sans vérifier la connexion
//     final pending = await _syncQueue.getPendingItemsByType();
//     final failed = await _syncQueue.getFailedCount();
//     final synced = await _syncQueue.getSyncedCount();
//     final pendingTotal = pending.values.fold(0, (sum, count) => sum + count);

//     setState(() {
//       _pendingByType = pending;
//       _pendingTotal = pendingTotal;
//       _failedTotal = failed;
//       _syncedTotal = synced;
//       _isSyncing = _syncQueue.isProcessing;
//       _isPaused = _syncQueue.isPaused;
//       // ✅ NE PAS mettre à jour _hasNetwork et _isApiReachable ici
//       _statusMessage = _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
//       _isLoading = false;
//     });
//   }

//   // ✅ Méthode complète avec vérification de connexion (pour le bouton refresh)
//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
//     setState(() => _isCheckingConnection = true);
//     await _connection.refresh();
//     setState(() => _isCheckingConnection = false);

//     await _refreshData();
//     setState(() => _isLoading = false);
//   }

//   Future<void> _refreshData() async {
//     setState(() => _isRefreshing = true);

//     final pending = await _syncQueue.getPendingItemsByType();
//     final failed = await _syncQueue.getFailedCount();
//     final synced = await _syncQueue.getSyncedCount();
//     final pendingTotal = pending.values.fold(0, (sum, count) => sum + count);

//     setState(() {
//       _pendingByType = pending;
//       _pendingTotal = pendingTotal;
//       _failedTotal = failed;
//       _syncedTotal = synced;
//       _isSyncing = _syncQueue.isProcessing;
//       _isPaused = _syncQueue.isPaused;
//       _hasNetwork = _connection.hasNetwork;
//       _isApiReachable = _connection.isApiReachable;
//       _statusMessage = _isSyncing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
//       _isRefreshing = false;
//     });
//   }

//   void _listenToSyncUpdates() {
//     _queueStatusSub = _syncQueue.queueStatusStream.listen((isProcessing) {
//       setState(() {
//         _isSyncing = isProcessing;
//         _statusMessage = isProcessing ? 'sync_in_progress'.tr : 'sync_status_idle'.tr;
//       });
//       if (!isProcessing) _refreshData();
//     });

//     _progressSub = _syncQueue.progressStream.listen((progress) {
//       setState(() => _progress = progress);
//     });

//     _networkSub = _connection.connectionStream.listen((hasNetwork) {
//       setState(() => _hasNetwork = hasNetwork);
//     });

//     _apiReachableSub = _connection.apiReachableStream.listen((reachable) {
//       setState(() => _isApiReachable = reachable);
//       _refreshData();
//     });

//     _pauseStatusSub = _syncQueue.pauseStatusStream.listen((isPaused) {
//       setState(() => _isPaused = isPaused);
//     });
//   }

//   bool get _isFullyConnected => _hasNetwork && _isApiReachable;

//   // ✅ Vérifier s'il y a des données à synchroniser
//   bool get _hasDataToSync => _pendingTotal > 0 || _failedTotal > 0;

//   @override
//   Widget build(BuildContext context) {
//     // ✅ Vérifier si tout est synchronisé
//     final bool isAllSynced = !_isLoading &&
//                              _pendingTotal == 0 &&
//                              _failedTotal == 0 &&
//                              !_isSyncing &&
//                              !_isCheckingConnection;

//     return Scaffold(
//       backgroundColor: AppColors.backgroundGrey,
//       appBar: AppBar(
//         title: Text('sync_status'.tr),
//         backgroundColor: AppColors.primaryGreen,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: _isRefreshing || _isCheckingConnection
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.refresh),
//             onPressed: (_isRefreshing || _isCheckingConnection) ? null : _loadData,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Center(
//               child: isAllSynced
//                   ? _buildGoldenIconWithText()
//                   : _buildSyncContent(),
//             ),
//     );
//   }

//   // ✅ Icône dorée avec texte en bas
//   Widget _buildGoldenIconWithText() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(32),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFFFFD700),
//                 Color(0xFFFFA500),
//                 Color(0xFFFFD700),
//               ],
//             ),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.amber.withOpacity(0.4),
//                 blurRadius: 40,
//                 spreadRadius: 10,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.cloud_done_rounded,
//             color: Colors.white,
//             size: 80,
//           ),
//         ),
//         const SizedBox(height: 24),
//         Text(
//           'all_synced'.tr,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF7A5C00),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'all_data_synced_successfully'.tr,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.brown.shade700,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.amber.shade100,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.amber.shade300),
//           ),
//           child: Text(
//             '${_syncedTotal} ${'items_synced'.tr}',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: Colors.brown.shade700,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ✅ Contenu de synchronisation
//   Widget _buildSyncContent() {
//     return RefreshIndicator(
//       onRefresh: _loadData,
//       color: AppColors.primaryGreen,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 600),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildConnectionStatus(),
//                 const SizedBox(height: 20),
//                 _buildStatsGrid(),
//                 const SizedBox(height: 20),
//                 if (_isSyncing || _pendingTotal > 0) ...[
//                   _buildProgressSection(),
//                   const SizedBox(height: 20),
//                 ],
//                 if (_failedTotal > 0) ...[
//                   _buildFailedBanner(),
//                   const SizedBox(height: 20),
//                 ],
//                 _buildBatchSizeSelector(),
//                 const SizedBox(height: 20),
//                 if (_pendingTotal > 0) ...[
//                   _buildPendingItemsList(),
//                   const SizedBox(height: 20),
//                 ],
//                 _buildActionButtons(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // -------------------------------------------------------------------
//   // Statut de connexion
//   // -------------------------------------------------------------------
//   Widget _buildConnectionStatus() {
//     final Color color;
//     final IconData icon;
//     final String label;

//     if (!_hasNetwork) {
//       color = Colors.red;
//       icon = Icons.wifi_off_rounded;
//       label = 'connection_offline'.tr;
//     } else if (!_isApiReachable) {
//       color = Colors.orange;
//       icon = Icons.cloud_off_rounded;
//       label = 'connected_no_server'.tr;
//     } else {
//       color = Colors.green;
//       icon = Icons.wifi_rounded;
//       label = 'connection_online'.tr;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.3), width: 1.5),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//             child: Icon(icon, color: Colors.white, size: 16),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
//                 ),
//                 if (_isFullyConnected)
//                   Text(
//                     'Via ${_connection.activeResourceLabel}',
//                     style: TextStyle(color: color.withOpacity(0.8), fontSize: 11.5),
//                   ),
//               ],
//             ),
//           ),
//           if (_isFullyConnected)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
//               child: Text(
//                 'online'.tr,
//                 style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // -------------------------------------------------------------------
//   // Grille de stats
//   // -------------------------------------------------------------------
//   Widget _buildStatsGrid() {
//     return Row(
//       children: [
//         Expanded(
//           child: _statTile(
//             icon: Icons.cloud_queue_rounded,
//             label: 'total_pending'.tr,
//             value: '$_pendingTotal',
//             color: AppColors.statBlue,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _statTile(
//             icon: Icons.check_circle_rounded,
//             label: 'synced'.tr,
//             value: '$_syncedTotal',
//             color: AppColors.primaryGreen,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _statTile(
//             icon: Icons.error_outline_rounded,
//             label: 'failed'.tr,
//             value: '$_failedTotal',
//             color: _failedTotal > 0 ? AppColors.badgeOrange : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _statTile({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 8),
//           Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------------------------------------------------------
//   // Progression de la synchro
//   // -------------------------------------------------------------------
//   Widget _buildProgressSection() {
//     final remaining = _pendingTotal;
//     final totalThisRun = _syncQueue.totalItemsThisRun > 0 ? _syncQueue.totalItemsThisRun : _pendingTotal;

//     return _cardShell(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   'sync_progress'.tr,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: (_isSyncing ? AppColors.statBlue : AppColors.primaryGreen).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${(_progress * 100).toInt()}%',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: _isSyncing ? AppColors.statBlue : AppColors.primaryGreen,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: _progress,
//               minHeight: 10,
//               backgroundColor: Colors.grey.shade100,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 _isSyncing ? AppColors.statBlue : AppColors.primaryGreen,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   '$remaining ${'remaining_to_sync'.tr} / $totalThisRun',
//                   style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Flexible(
//                 child: Text(
//                   _statusMessage,
//                   style: TextStyle(
//                     fontSize: 12.5,
//                     color: _isSyncing ? AppColors.statBlue : Colors.grey.shade600,
//                     fontWeight: _isSyncing ? FontWeight.w600 : FontWeight.normal,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFailedBanner() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.badgeOrange.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.badgeOrange.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.warning_amber_rounded, color: AppColors.badgeOrange),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               '$_failedTotal ${'items_failed_to_sync'.tr}',
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           TextButton(
//             onPressed: _isRetryingFailed ? null : _retryFailed,
//             child: _isRetryingFailed
//                 ? const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : Text('retry'.tr),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------------------------------------------------------
//   // Sélecteur de taille de lot
//   // -------------------------------------------------------------------
//   Widget _buildBatchSizeSelector() {
//     return _cardShell(
//       child: Row(
//         children: [
//           const Icon(Icons.dns_outlined, color: AppColors.primaryGreen, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text('batch_size'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
//           ),
//           ..._batchSizeOptions.map((size) {
//             final selected = size == _selectedBatchSize;
//             return Padding(
//               padding: const EdgeInsets.only(left: 6),
//               child: ChoiceChip(
//                 label: Text('$size'),
//                 selected: selected,
//                 onSelected: (_) {
//                   setState(() => _selectedBatchSize = size);
//                   _syncQueue.setBatchSize(size);
//                 },
//                 selectedColor: AppColors.primaryGreen,
//                 labelStyle: TextStyle(
//                   color: selected ? Colors.white : AppColors.textPrimary,
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 backgroundColor: Colors.grey.shade100,
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingItemsList() {
//     final items = _pendingByType.entries.where((e) => e.value > 0).toList();

//     return _cardShell(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   'pending_items'.tr,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                 decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
//                 child: Text(
//                   '$_pendingTotal',
//                   style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w700, fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//           Divider(height: 24, color: Colors.grey.shade100),
//           if (items.isEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Text('no_data_to_sync'.tr, style: TextStyle(color: Colors.grey.shade500)),
//             )
//           else
//             ...items.map((entry) => _buildCategoryItem(key: entry.key, count: entry.value)),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryItem({required String key, required int count}) {
//     final icon = _getCategoryIcon(key);
//     final label = _getCategoryLabel(key);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: const BoxDecoration(color: AppColors.statBlue, shape: BoxShape.circle),
//               child: Icon(icon, color: Colors.white, size: 16),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//               decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
//               child: Text(
//                 '$count',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.orange.shade700),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getCategoryIcon(String key) {
//     switch (key) {
//       case 'etablissements':
//         return Icons.school_rounded;
//       case 'sources':
//         return Icons.source_rounded;
//       case 'classes':
//         return Icons.class_rounded;
//       case 'specialites':
//         return Icons.category_rounded;
//       case 'fiches':
//         return Icons.description_rounded;
//       case 'prospects':
//         return Icons.people_rounded;
//       case 'interets':
//         return Icons.favorite_rounded;
//       default:
//         return Icons.circle_rounded;
//     }
//   }

//   String _getCategoryLabel(String key) {
//     switch (key) {
//       case 'etablissements':
//         return 'establishments'.tr;
//       case 'sources':
//         return 'sources'.tr;
//       case 'classes':
//         return 'classes'.tr;
//       case 'specialites':
//         return 'specialties'.tr;
//       case 'fiches':
//         return 'fiches'.tr;
//       case 'prospects':
//         return 'prospects'.tr;
//       case 'interets':
//         return 'interests'.tr;
//       default:
//         return key;
//     }
//   }

//   // -------------------------------------------------------------------
//   // BOUTONS D'ACTION
//   // -------------------------------------------------------------------
//   Widget _buildActionButtons() {
//     final bool hasDataToSync = _pendingTotal > 0 || _failedTotal > 0;
//     final bool isButtonEnabled = hasDataToSync && !_isSyncing;

//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: isButtonEnabled ? _startSync : null,
//             icon: _isSyncing
//                 ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.sync_rounded),
//             label: Text(_isSyncing ? 'syncing'.tr : 'sync_now'.tr),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isButtonEnabled ? AppColors.primaryGreen : Colors.grey.shade400,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: OutlinedButton.icon(
//             onPressed: _isRefreshing ? null : _loadData,
//             icon: const Icon(Icons.refresh_rounded),
//             label: Text('refresh'.tr),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: AppColors.primaryGreen,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//               side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _cardShell({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))],
//       ),
//       child: child,
//     );
//   }

//   // -------------------------------------------------------------------
//   // MÉTHODES
//   // -------------------------------------------------------------------
//   Future<void> _togglePause() async {
//     if (_isPaused) {
//       await _syncQueue.resumeSync();
//     } else {
//       await _syncQueue.pauseSync();
//     }
//   }

//   Future<void> _startSync() async {
//     if (!_hasDataToSync) {
//       _showSnack('nothing_to_sync'.tr, Colors.orange);
//       return;
//     }

//     if (!_isFullyConnected) {
//       _showSnack(
//         _hasNetwork ? 'connected_no_server'.tr : 'no_connection'.tr,
//         Colors.red,
//       );
//       return;
//     }

//     try {
//       await _syncQueue.syncNow();
//     } catch (e) {
//       _showSnack('sync_error'.tr.replaceFirst('{error}', e.toString()), Colors.red);
//     }
//   }

//   Future<void> _retryFailed() async {
//     setState(() => _isRetryingFailed = true);
//     try {
//       await _syncQueue.retryFailedItems();
//       await _refreshData();
//     } finally {
//       if (mounted) setState(() => _isRetryingFailed = false);
//     }
//   }

//   void _showSnack(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isetagcom/utils/sync_queue.dart';
import 'package:isetagcom/utils/connection_checker.dart';
import 'package:isetagcom/services/translation_service.dart';
import 'package:isetagcom/utils/themes/app_colors.dart';

// ✅ SyncEventType enum for different sync events
enum SyncEventType {
  started,
  progress,
  completed,
  error,
  paused,
  resumed,
}

// ✅ SyncEvent class for sync events
class SyncEvent {
  final SyncEventType type;
  final String? message;
  final int? progress;

  SyncEvent({required this.type, this.message, this.progress});
}

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
  StreamController<SyncEvent>? _syncEventController;

  @override
  void initState() {
    super.initState();
    _selectedBatchSize = _syncQueue.batchSize;
    _syncEventController = StreamController<SyncEvent>.broadcast();
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
    _syncEventController?.close();
    super.dispose();
  }

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

      if (!_isSyncing) {
        _isSyncInterrupted = false;
        _lastError = null;
      }
    });
  }

  void _listenToSyncUpdates() {
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

    _progressSub = _syncQueue.progressStream.listen((progress) {
      setState(() => _progress = progress);
      if (_syncEventController != null && !_syncEventController!.isClosed) {
        _syncEventController!.add(SyncEvent(
          type: SyncEventType.progress,
          progress: (progress * 100).toInt(),
        ));
      }
    });

    _networkSub = _connection.connectionStream.listen((hasNetwork) {
      setState(() {
        _hasNetwork = hasNetwork;
      });
      if (!hasNetwork && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'connection_lost';
        setState(() {
          _statusMessage = 'connection_lost_during_sync'.tr;
        });
        if (_syncEventController != null && !_syncEventController!.isClosed) {
          _syncEventController!.add(SyncEvent(
            type: SyncEventType.error,
            message: 'connection_lost_during_sync'.tr,
          ));
        }
      }
      if (hasNetwork && _isSyncInterrupted && _isSyncing) {
        setState(() {
          _statusMessage = 'connection_restored_click_resume'.tr;
        });
      }
    });

    _apiReachableSub = _connection.apiReachableStream.listen((reachable) {
      setState(() {
        _isApiReachable = reachable;
      });
      if (!reachable && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'server_unreachable';
        setState(() {
          _statusMessage = 'connection_lost_during_sync'.tr;
        });
        if (_syncEventController != null && !_syncEventController!.isClosed) {
          _syncEventController!.add(SyncEvent(
            type: SyncEventType.error,
            message: 'server_unreachable'.tr,
          ));
        }
      }
      if (reachable && _isSyncInterrupted && _isSyncing) {
        setState(() {
          _statusMessage = 'connection_restored_click_resume'.tr;
        });
      }
    });

    _pauseStatusSub = _syncQueue.pauseStatusStream.listen((isPaused) {
      setState(() => _isPaused = isPaused);
      if (isPaused && _isSyncing) {
        _isSyncInterrupted = true;
        _lastError = 'paused';
        setState(() {
          _statusMessage = 'sync_paused'.tr;
        });
        if (_syncEventController != null && !_syncEventController!.isClosed) {
          _syncEventController!.add(SyncEvent(
            type: SyncEventType.paused,
            message: 'sync_paused'.tr,
          ));
        }
      }
    });
  }

  bool get _isFullyConnected => _hasNetwork && _isApiReachable;
  bool get _hasDataToSync =>
      _pendingTotal > 0 || _failedTotal > 0 || _updateTotal > 0;
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

  // -------------------------------------------------------------------
  // Statut de connexion
  // -------------------------------------------------------------------
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
                if (_isSyncInterrupted)
                  Text(
                    _lastError == 'server_error'
                        ? 'sync_interrupted_server_error'.tr
                        : 'connection_lost_during_sync'.tr,
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

// -------------------------------------------------------------------
// Grille de stats - Soft and compact 2x2
// -------------------------------------------------------------------
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
          // ✅ Row 1: Total Pending + To Update
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
          // ✅ Row 2: Synced + Failed
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
          // Soft icon
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
          // Value
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
          // Label
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

  // -------------------------------------------------------------------
  // Progression de la synchro
  // -------------------------------------------------------------------
  Widget _buildProgressSection() {
    final totalItems = _pendingTotal + _updateTotal;
    final remaining = totalItems;
    final totalThisRun = _syncQueue.totalItemsThisRun > 0
        ? _syncQueue.totalItemsThisRun
        : totalItems;

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
                  color:
                      (_isSyncing ? AppColors.statBlue : AppColors.primaryGreen)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _isSyncing
                        ? AppColors.statBlue
                        : AppColors.primaryGreen,
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
                    color: _isSyncInterrupted
                        ? Colors.red
                        : (_isSyncing
                            ? AppColors.statBlue
                            : Colors.grey.shade600),
                    fontWeight: _isSyncInterrupted
                        ? FontWeight.w700
                        : (_isSyncing ? FontWeight.w600 : FontWeight.normal),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          // ✅ Show update count if there are updates
          if (_updateTotal > 0 && !_isSyncing) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.update_rounded,
                      color: Colors.orange.shade700, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${_updateTotal} ${'items_to_update'.tr}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_isSyncInterrupted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _lastError == 'server_error'
                    ? Colors.red.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _lastError == 'server_error'
                      ? Colors.red.shade200
                      : Colors.orange.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _lastError == 'server_error'
                        ? Icons.error_outline
                        : Icons.warning_amber_rounded,
                    color: _lastError == 'server_error'
                        ? Colors.red
                        : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lastError == 'server_error'
                          ? 'sync_interrupted_server_error'.tr
                          : 'connection_lost_during_sync'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _lastError == 'server_error'
                            ? Colors.red
                            : Colors.orange,
                      ),
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
          const Icon(Icons.warning_amber_rounded, color: AppColors.badgeOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$_failedTotal ${'items_failed_to_sync'.tr}',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
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

  // -------------------------------------------------------------------
  // Sélecteur de taille de lot
  // -------------------------------------------------------------------
  Widget _buildBatchSizeSelector() {
    return _cardShell(
      child: Row(
        children: [
          const Icon(Icons.dns_outlined,
              color: AppColors.primaryGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text('batch_size'.tr,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13.5)),
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
    final allItems = <Map<String, dynamic>>[];

    // Add pending items
    for (final entry in _pendingByType.entries) {
      if (entry.value > 0) {
        allItems.add({
          'key': entry.key,
          'count': entry.value,
          'type': 'pending',
        });
      }
    }

    // Add update items
    for (final entry in _updateByType.entries) {
      if (entry.value > 0) {
        allItems.add({
          'key': entry.key,
          'count': entry.value,
          'type': 'update',
        });
      }
    }

    // Sort: updates first, then pending
    allItems.sort((a, b) {
      if (a['type'] == 'update' && b['type'] != 'update') return -1;
      if (a['type'] != 'update' && b['type'] == 'update') return 1;
      return 0;
    });

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
          if (allItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('no_data_to_sync'.tr,
                  style: TextStyle(color: Colors.grey.shade500)),
            )
          else
            ...allItems.map((item) => _buildCategoryItem(
                  key: item['key'],
                  count: item['count'],
                  isUpdate: item['type'] == 'update',
                )),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      {required String key, required int count, bool isUpdate = false}) {
    final icon = _getCategoryIcon(key);
    final label = _getCategoryLabel(key);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUpdate ? Colors.orange.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: isUpdate ? Border.all(color: Colors.orange.shade200) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isUpdate ? Colors.orange : AppColors.statBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isUpdate ? '${label} (${'to_update'.tr})' : label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isUpdate ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isUpdate ? Colors.orange.shade700 : Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isUpdate ? Colors.orange.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isUpdate
                      ? Colors.orange.shade700
                      : Colors.orange.shade700,
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

  // -------------------------------------------------------------------
  // BOUTONS D'ACTION
  // -------------------------------------------------------------------
  Widget _buildActionButtons() {
    final bool hasDataToSync =
        _pendingTotal > 0 || _failedTotal > 0 || _updateTotal > 0;

    if (_showResumeButton) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _resumeSync,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('resume'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _lastError == 'server_error' ? Colors.red : Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isRefreshing ? null : _loadData,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('refresh'.tr),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                side:
                    BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      );
    }

    final bool isButtonEnabled =
        hasDataToSync && !_isSyncing && !_isSyncInterrupted;

    return Row(
      children: [
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
              backgroundColor: isButtonEnabled
                  ? AppColors.primaryGreen
                  : Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isRefreshing ? null : _loadData,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('refresh'.tr),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Resume sync after interruption
  // -------------------------------------------------------------------
  Future<void> _resumeSync() async {
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
      setState(() {
        _statusMessage = 'resuming_sync'.tr;
        _isSyncInterrupted = false;
        _isSyncing = true;
        _lastError = null;
      });
      await _syncQueue.resumeSync();
      _showSnack('sync_resumed'.tr, Colors.green);
      await _refreshData();
    } catch (e) {
      setState(() {
        _isSyncInterrupted = true;
        _lastError = 'server_error';
        _isSyncing = false;
        _statusMessage = 'sync_interrupted_server_error'.tr;
      });
      _showSnack(
          'sync_error'.tr.replaceFirst('{error}', e.toString()), Colors.red);
    }
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

  // -------------------------------------------------------------------
  // MÉTHODES
  // -------------------------------------------------------------------
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
      setState(() {
        _isSyncInterrupted = false;
        _lastError = null;
        _isSyncing = true;
      });
      await _syncQueue.syncNow();
    } catch (e) {
      setState(() {
        _isSyncInterrupted = true;
        _lastError = 'server_error';
        _isSyncing = false;
        _statusMessage = 'sync_interrupted_server_error'.tr;
      });
      _showSnack(
          'sync_error'.tr.replaceFirst('{error}', e.toString()), Colors.red);
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
