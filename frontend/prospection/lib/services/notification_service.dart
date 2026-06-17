import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialiser timezone avec les données
    tz.initializeTimeZones();

    // Utiliser le fuseau horaire local du système
    try {
      tz.setLocalLocation(tz.local);
    } catch (e) {
      final location = tz.getLocation('Africa/Lagos');
      tz.setLocalLocation(location);
    }
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  /// Générer un ID valide (entre 0 et 2^31-1)
  int _generateValidId(DateTime dateTime) {
    int rawId = dateTime.millisecondsSinceEpoch % 2147483647;
    rawId = (rawId % 2147482647) + 1000;
    return rawId;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    DateTime? scheduledTime,
    String? payload,
  }) async {
    final int id = scheduledTime != null
        ? _generateValidId(scheduledTime)
        : _generateValidId(DateTime.now());

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'relance_channel',
      'Notifications de relance',
      channelDescription: 'Notifications pour les relances de prospects',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      // showBadge: true,
      color: Color(0xFF2E7D32), // Vert ISETAG
      colorized: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/app_icon'),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (scheduledTime != null) {
      try {
        final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
          payload: payload,
        );
      } catch (e) {
        print('Erreur programmation notification: $e');
        await _notifications.show(
          id: id,
          title: title,
          body: body,
          notificationDetails: details,
          payload: payload,
        );
      }
    } else {
      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    }
  }

  // ✅ AJOUTER CETTE MÉTHODE
  Future<void> showOverdueNotification({
    required String prospectName,
    required String prospectId,
  }) async {
    await showNotification(
      title: '⚠️ Relance en retard',
      body: 'La relance pour $prospectName est en retard',
      payload: 'overdue_$prospectId',
    );
  }

  // ✅ AJOUTER CETTE MÉTHODE
  Future<void> showReminderNotification({
    required String prospectName,
    required String prospectId,
    DateTime? scheduledTime,
  }) async {
    await showNotification(
      title: '🔄 Relance programmée',
      body: 'N\'oubliez pas de relancer $prospectName',
      scheduledTime: scheduledTime,
      payload: 'prospect_$prospectId',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
