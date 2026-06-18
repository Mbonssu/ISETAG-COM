// lib/widgets/sync_progress.dart
import 'package:flutter/material.dart';
import 'package:isetagcom/utils/sync_queue.dart';

class SyncProgress extends StatefulWidget {
  const SyncProgress({super.key});

  @override
  State<SyncProgress> createState() => _SyncProgressState();
}

class _SyncProgressState extends State<SyncProgress> {
  final SyncQueue _syncQueue = SyncQueue();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _syncQueue.queueStatusStream,
      initialData: false,
      builder: (context, snapshot) {
        final hasPending = snapshot.data ?? false;
        
        if (!hasPending) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<double>(
          stream: _syncQueue.progressStream,
          initialData: 0.0,
          builder: (context, progressSnapshot) {
            final progress = progressSnapshot.data ?? 0.0;
            
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Synchronisation en cours...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}