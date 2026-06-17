// // lib/widgets/sync_toast.dart
// import 'package:flutter/material.dart';
// import 'package:isetagcom/services/sync_service.dart';

// class SyncToast extends StatefulWidget {
//   final Widget child;

//   const SyncToast({super.key, required this.child});

//   @override
//   State<SyncToast> createState() => _SyncToastState();
// }

// class _SyncToastState extends State<SyncToast> with SingleTickerProviderStateMixin {
//   final SyncService _syncService = SyncService();
  
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   String _statusMessage = '';
//   Color _backgroundColor = Colors.blue;
//   IconData _icon = Icons.sync;
//   bool _isVisible = false;
//   double _progress = 0.0;

//   @override
//   void initState() {
//     super.initState();
    
//     // Setup animations
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, -1.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
    
//     _fadeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));

//     // Listen to sync status changes
//     _syncService.statusStream.listen((status) {
//       _updateStatus(status);
//     });

//     _syncService.progressStream.listen((progress) {
//       setState(() {
//         _progress = progress;
//       });
//     });
//   }

//   void _updateStatus(SyncStatus status) {
//     setState(() {
//       switch (status) {
//         case SyncStatus.idle:
//           _hideToast();
//           break;
//         case SyncStatus.syncing:
//           _statusMessage = 'Synchronisation en cours...';
//           _backgroundColor = Colors.blue;
//           _icon = Icons.sync;
//           _isVisible = true;
//           _controller.forward();
//           break;
//         case SyncStatus.completed:
//           _statusMessage = '✅ Synchronisation terminée !';
//           _backgroundColor = Colors.green;
//           _icon = Icons.check_circle;
//           _isVisible = true;
//           _controller.forward();
//           Future.delayed(const Duration(seconds: 3), _hideToast);
//           break;
//         case SyncStatus.failed:
//           _statusMessage = '❌ Échec de synchronisation';
//           _backgroundColor = Colors.red;
//           _icon = Icons.error;
//           _isVisible = true;
//           _controller.forward();
//           Future.delayed(const Duration(seconds: 4), _hideToast);
//           break;
//       }
//     });
//   }

//   void _hideToast() {
//     if (_isVisible) {
//       _controller.reverse().then((_) {
//         setState(() {
//           _isVisible = false;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         widget.child,
//         if (_isVisible)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SafeArea(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: Material(
//                     elevation: 4,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       color: _backgroundColor,
//                       child: Row(
//                         children: [
//                           if (_syncService.status == SyncStatus.syncing)
//                             const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             )
//                           else
//                             Icon(_icon, color: Colors.white, size: 20),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _statusMessage,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 if (_syncService.status == SyncStatus.syncing)
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(4),
//                                     child: LinearProgressIndicator(
//                                       value: _progress,
//                                       backgroundColor: Colors.white24,
//                                       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                                       minHeight: 3,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           if (_syncService.status == SyncStatus.syncing)
//                             Text(
//                               '${(_progress * 100).toInt()}%',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: _hideToast,
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }




// class SyncFloatingButton extends StatefulWidget {
//   final VoidCallback? onSyncTap;

//   const SyncFloatingButton({super.key, this.onSyncTap});

//   @override
//   State<SyncFloatingButton> createState() => _SyncFloatingButtonState();
// }

// class _SyncFloatingButtonState extends State<SyncFloatingButton> {
//   final SyncService _syncService = SyncService();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<SyncStatus>(
//       stream: _syncService.statusStream,
//       initialData: SyncStatus.idle,
//       builder: (context, statusSnapshot) {
//         final status = statusSnapshot.data ?? SyncStatus.idle;
        
//         return StreamBuilder<double>(
//           stream: _syncService.progressStream,
//           initialData: 0.0,
//           builder: (context, progressSnapshot) {
//             final progress = progressSnapshot.data ?? 0.0;
            
//             return Positioned(
//               bottom: 20,
//               right: 20,
//               child: FloatingActionButton.extended(
//                 onPressed: status == SyncStatus.syncing
//                     ? null
//                     : () {
//                         if (widget.onSyncTap != null) {
//                           widget.onSyncTap!();
//                         } else {
//                           _syncService.manualSync();
//                         }
//                       },
//                 backgroundColor: _getColor(status),
//                 icon: _getIcon(status),
//                 label: _getLabel(status, progress),
//                 extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Color _getColor(SyncStatus status) {
//     switch (status) {
//       case SyncStatus.idle:
//         return Colors.blue;
//       case SyncStatus.syncing:
//         return Colors.orange;
//       case SyncStatus.completed:
//         return Colors.green;
//       case SyncStatus.failed:
//         return Colors.red;
//     }
//   }

//   Widget _getIcon(SyncStatus status) {
//     switch (status) {
//       case SyncStatus.idle:
//         return const Icon(Icons.cloud_upload_outlined);
//       case SyncStatus.syncing:
//         return const SizedBox(
//           width: 24,
//           height: 24,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         );
//       case SyncStatus.completed:
//         return const Icon(Icons.cloud_done);
//       case SyncStatus.failed:
//         return const Icon(Icons.cloud_off);
//     }
//   }

//   Widget _getLabel(SyncStatus status, double progress) {
//     switch (status) {
//       case SyncStatus.idle:
//         return const Text('Sync');
//       case SyncStatus.syncing:
//         return Text('${(progress * 100).toInt()}%');
//       case SyncStatus.completed:
//         return const Text('Synced');
//       case SyncStatus.failed:
//         return const Text('Retry');
//     }
//   }
// }




// lib/widgets/sync_toast.dart (Full version with localization)
import 'package:flutter/material.dart';
import 'package:isetagcom/services/sync_service.dart';
import 'package:isetagcom/services/translation_service.dart';

class SyncToast extends StatefulWidget {
  final Widget child;

  const SyncToast({super.key, required this.child});

  @override
  State<SyncToast> createState() => _SyncToastState();
}

class _SyncToastState extends State<SyncToast> with SingleTickerProviderStateMixin {
  final SyncService _syncService = SyncService();
  
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _statusMessage = '';
  Color _backgroundColor = Colors.blue;
  IconData _icon = Icons.sync;
  bool _isVisible = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _syncService.statusStream.listen((status) {
      _updateStatus(status);
    });

    _syncService.progressStream.listen((progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  void _updateStatus(SyncStatus status) {
    setState(() {
      switch (status) {
        case SyncStatus.idle:
          _hideToast();
          break;
        case SyncStatus.syncing:
          _statusMessage = 'Synchronisation en cours...'.tr;
          _backgroundColor = Colors.blue;
          _icon = Icons.sync;
          _isVisible = true;
          _controller.forward();
          break;
        case SyncStatus.completed:
          _statusMessage = '✅ Synchronisation terminée !'.tr;
          _backgroundColor = Colors.green;
          _icon = Icons.check_circle;
          _isVisible = true;
          _controller.forward();
          Future.delayed(const Duration(seconds: 3), _hideToast);
          break;
        case SyncStatus.failed:
          _statusMessage = '❌ Échec de synchronisation'.tr;
          _backgroundColor = Colors.red;
          _icon = Icons.error;
          _isVisible = true;
          _controller.forward();
          Future.delayed(const Duration(seconds: 4), _hideToast);
          break;
      }
    });
  }

  void _hideToast() {
    if (_isVisible) {
      _controller.reverse().then((_) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isVisible)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Material(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: _backgroundColor,
                      child: Row(
                        children: [
                          if (_syncService.status == SyncStatus.syncing)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          else
                            Icon(_icon, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _statusMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_syncService.status == SyncStatus.syncing)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _progress,
                                      backgroundColor: Colors.white24,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      minHeight: 3,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_syncService.status == SyncStatus.syncing)
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _hideToast,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}