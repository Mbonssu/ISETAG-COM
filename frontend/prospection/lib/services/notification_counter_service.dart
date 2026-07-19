// services/notification_counter_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCounterService {
  static final NotificationCounterService _instance = 
      NotificationCounterService._internal();
  factory NotificationCounterService() => _instance;
  NotificationCounterService._internal();

  static const String _notificationKey = 'pending_notifications';
  static const String _notificationCountKey = 'notification_count';

  // ✅ Ajouter une notification (payload)
  Future<void> addNotification(String payload) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList(_notificationKey) ?? [];
      if (!notifications.contains(payload)) {
        notifications.add(payload);
        await prefs.setStringList(_notificationKey, notifications);
        await _updateCount(notifications.length);
        print('✅ Notification ajoutée: $payload (total: ${notifications.length})');
      }
    } catch (e) {
      print('❌ Error storing notification: $e');
    }
  }

  // ✅ Supprimer une notification
  Future<void> removeNotification(String payload) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList(_notificationKey) ?? [];
      if (notifications.contains(payload)) {
        notifications.remove(payload);
        await prefs.setStringList(_notificationKey, notifications);
        await _updateCount(notifications.length);
        print('✅ Notification supprimée: $payload (total: ${notifications.length})');
      }
    } catch (e) {
      print('❌ Error removing notification: $e');
    }
  }

  // ✅ Mettre à jour le compteur
  Future<void> _updateCount(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_notificationCountKey, count);
    } catch (e) {
      print('❌ Error updating count: $e');
    }
  }

  // ✅ Récupérer le nombre de notifications
  Future<int> getNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_notificationCountKey) ?? 0;
    } catch (e) {
      print('❌ Error getting count: $e');
      return 0;
    }
  }

  // ✅ Récupérer toutes les notifications
  Future<List<String>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_notificationKey) ?? [];
    } catch (e) {
      print('❌ Error getting notifications: $e');
      return [];
    }
  }

  // ✅ Supprimer toutes les notifications
  Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationKey);
      await prefs.remove(_notificationCountKey);
      print('✅ Toutes les notifications supprimées');
    } catch (e) {
      print('❌ Error clearing notifications: $e');
    }
  }

  // ✅ Vérifier si une notification existe
  Future<bool> hasNotification(String payload) async {
    try {
      final notifications = await getNotifications();
      return notifications.contains(payload);
    } catch (e) {
      print('❌ Error checking notification: $e');
      return false;
    }
  }
}