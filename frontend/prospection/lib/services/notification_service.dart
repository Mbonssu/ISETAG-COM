// import 'dart:typed_data';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

// // ⚠️ FONCTION TOP-LEVEL pour le background (hors de la classe)
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
//   print('📱 Notification en arrière-plan reçue: ${details.payload}');

//   if (details.payload != null) {
//     _storeNotificationPayload(details.payload!);
//   }
// }

// void _storeNotificationPayload(String payload) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final notifications = prefs.getStringList('pending_notifications') ?? [];
//     if (!notifications.contains(payload)) {
//       notifications.add(payload);
//       await prefs.setStringList('pending_notifications', notifications);
//     }
//   } catch (e) {
//     print('❌ Error storing notification payload: $e');
//   }
// }

// class NotificationService {
//   NotificationService._();

//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin plugin =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   Function(String?)? _onNotificationTap;

//   // ─── Initialisation ──────────────────────────────────────────────────────

//   Future<void> initialize({Function(String?)? onNotificationTap}) async {
//     if (_isInitialized) return;

//     _onNotificationTap = onNotificationTap;

//     tz.initializeTimeZones();

//     const android = AndroidInitializationSettings('@mipmap/app_icon');

//     const ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       defaultPresentAlert: true,
//       defaultPresentBadge: true,
//       defaultPresentSound: true,
//     );

//     const settings = InitializationSettings(
//       android: android,
//       iOS: ios,
//     );

//     await plugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         _handleNotificationTap(details);
//       },
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveBackgroundNotificationResponse,
//     );

//     await _createAndroidChannels();
//     await _requestPermissions();

//     _isInitialized = true;

//     print('✅ NotificationService initialisé avec succès');
//   }

//   // ─── Canaux Android ──────────────────────────────────────────────────────

//   Future<void> _createAndroidChannels() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android == null) return;

//     // ✅ Canal pour les relances - IMPORTANCE MAX pour ne pas disparaître
//     final relanceChannel = AndroidNotificationChannel(
//       'relance_channel',
//       'Relances Prospect',
//       description: 'Notifications des relances de prospects',
//       importance: Importance.max,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//       playSound: true,
//       // ✅ Ajouter ces propriétés pour que la notification reste
//       showBadge: true,
//       enableLights: true,
//     );

//     final reminderChannel = AndroidNotificationChannel(
//       'reminder_channel',
//       'Rappels',
//       description: 'Rappels des événements importants',
//       importance: Importance.high,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 300, 200, 300]),
//       showBadge: true,
//     );

//     const generalChannel = AndroidNotificationChannel(
//       'general_channel',
//       'Notifications Générales',
//       description: 'Notifications générales de l\'application',
//       importance: Importance.defaultImportance,
//     );

//     // ✅ Canal pour les notifications groupées
//     const groupChannel = AndroidNotificationChannel(
//       'group_channel',
//       'Relances Groupées',
//       description: 'Résumé des relances à effectuer',
//       importance: Importance.high,
//     );

//     await android.createNotificationChannel(relanceChannel);
//     await android.createNotificationChannel(reminderChannel);
//     await android.createNotificationChannel(generalChannel);
//     await android.createNotificationChannel(groupChannel);

//     print('✅ Canaux Android créés avec succès');
//   }

//   // ─── Permissions ──────────────────────────────────────────────────────────

//   Future<void> _requestPermissions() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android != null) {
//       await android.requestNotificationsPermission();
//     }

//     final ios = plugin.resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>();

//     if (ios != null) {
//       await ios.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     print('✅ Permissions de notification demandées');
//   }

//   // ─── Gestion des clics ────────────────────────────────────────────────────

//   void _handleNotificationTap(NotificationResponse details) {
//     final payload = details.payload;
//     print('📱 Notification cliquée: $payload');

//     if (_onNotificationTap != null) {
//       _onNotificationTap!(payload);
//     }
//   }

//   // ─── Utilitaires ──────────────────────────────────────────────────────────

//   int _getNotificationId(String prospectId) {
//     return prospectId.hashCode & 0x7fffffff;
//   }

//   NotificationDetails _getDetails(String channelId) {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         channelId,
//         channelId == 'relance_channel'
//             ? 'Relances Prospect'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels'
//                 : channelId == 'group_channel'
//                     ? 'Relances Groupées'
//                     : 'Notifications Générales',
//         channelDescription: channelId == 'relance_channel'
//             ? 'Notifications des relances de prospects'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels des événements importants'
//                 : channelId == 'group_channel'
//                     ? 'Résumé des relances à effectuer'
//                     : 'Notifications générales de l\'application',
//         importance: channelId == 'relance_channel'
//             ? Importance.max
//             : channelId == 'reminder_channel'
//                 ? Importance.high
//                 : Importance.defaultImportance,
//         priority: channelId == 'relance_channel'
//             ? Priority.high
//             : channelId == 'reminder_channel'
//                 ? Priority.max
//                 : Priority.defaultPriority,
//         enableVibration: true,
//         vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//         playSound: true,
//         styleInformation: const BigTextStyleInformation(''),
//         // ✅ CHANGEMENT CRUCIAL: autoCancel: false pour garder la notification
//         autoCancel: false,
//         // ✅ Timeout plus long (5 minutes)
//         timeoutAfter: 300000,
//         showWhen: true,
//         when: DateTime.now().millisecondsSinceEpoch,
//         // ✅ Forcer l'affichage même quand l'app est en arrière-plan
//         ongoing: channelId == 'relance_channel' ? false : false,
//         // ✅ Permettre à l'utilisateur de swiper pour supprimer
//         // mais pas de disparition automatique
//       ),
//       iOS: const DarwinNotificationDetails(
//         categoryIdentifier: 'relance_category',
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         interruptionLevel: InterruptionLevel.timeSensitive,
//       ),
//     );
//   }

//   // ─── Afficher une notification immédiatement ────────────────────────────

//   Future<void> showNow({
//     required String title,
//     required String body,
//     String? payload,
//     String channelId = 'general_channel',
//   }) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       await plugin.show(
//         id,
//         title,
//         body,
//         _getDetails(channelId),
//         payload: payload,
//       );

//       print('✅ Notification immédiate affichée: "$title"');
//     } catch (e) {
//       print('❌ Erreur lors de l\'affichage de la notification: $e');
//     }
//   }

//   // ─── Programmer une notification ─────────────────────────────────────────

//   Future<void> scheduleReminder({
//     required String prospectId,
//     required String prospectName,
//     required DateTime date,
//     String? comment,
//   }) async {
//     try {
//       if (date.isBefore(DateTime.now())) {
//         print('⚠️ La date de relance est déjà passée');
//         return;
//       }

//       final id = _getNotificationId(prospectId);

//       await cancelReminder(prospectId);

//       final scheduledDate = tz.TZDateTime.from(date, tz.local);

//       final title = '🔔 Relance Prospect';
//       final body = comment?.isNotEmpty == true
//           ? 'Relancer $prospectName: $comment'
//           : 'N\'oubliez pas de relancer $prospectName';

//       await plugin.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         _getDetails('relance_channel'),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: prospectId,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );

//       print('✅ Notification programmée pour $prospectName le ${date.toString()}');
//     } catch (e) {
//       print('❌ Erreur lors de la programmation: $e');
//     }
//   }

//   // ─── Programmer des notifications groupées ──────────────────────────────

//   Future<void> scheduleGroupedReminders({
//     required List<Map<String, dynamic>> prospects,
//     required DateTime date,
//   }) async {
//     try {
//       if (prospects.isEmpty) return;

//       final count = prospects.length;
//       final scheduledDate = tz.TZDateTime.from(date, tz.local);

//       if (count > 5) {
//         for (final prospect in prospects) {
//           await cancelReminder(prospect['id']);
//         }

//         final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//         final title = '📋 $count prospects à relancer';
//         final names = prospects.take(5).map((p) => '• ${p['name']}').join('\n');
//         final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//         final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//         await plugin.zonedSchedule(
//           id,
//           title,
//           body,
//           scheduledDate,
//           _getDetails('group_channel'),
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           payload: 'group_${prospects.map((p) => p['id']).join(',')}',
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//         );

//         print('✅ Notification groupée programmée pour $count prospects');
//       } else {
//         for (final prospect in prospects) {
//           await scheduleReminder(
//             prospectId: prospect['id'],
//             prospectName: prospect['name'],
//             date: date,
//             comment: prospect['comment'],
//           );
//         }
//       }
//     } catch (e) {
//       print('❌ Erreur lors de la programmation groupée: $e');
//     }
//   }

//   // ─── Annuler une notification ────────────────────────────────────────────

//   Future<void> cancelReminder(String prospectId) async {
//     try {
//       final id = _getNotificationId(prospectId);
//       await plugin.cancel(id);
//       print('✅ Notification annulée pour le prospect $prospectId');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Annuler toutes les notifications ────────────────────────────────────

//   Future<void> cancelAll() async {
//     try {
//       await plugin.cancelAll();
//       print('✅ Toutes les notifications ont été annulées');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Récupérer les notifications en attente ─────────────────────────────

//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     try {
//       return await plugin.pendingNotificationRequests();
//     } catch (e) {
//       print('❌ Erreur lors de la récupération des notifications: $e');
//       return [];
//     }
//   }

//   // ─── Vérifier si une notification est programmée ─────────────────────────

//   Future<bool> isNotificationScheduled(String prospectId) async {
//     try {
//       final pending = await getPendingNotifications();
//       final id = _getNotificationId(prospectId);
//       return pending.any((n) => n.id == id);
//     } catch (e) {
//       return false;
//     }
//   }

//   // ─── Notifications spécifiques ───────────────────────────────────────────

//   Future<void> showRelanceNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '🔔 Relance recommandée';
//     final body = 'Le prospect $prospectName devrait être relancé aujourd\'hui !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'relance_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showNewProspectNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📝 Nouveau Prospect';
//     final body = '$prospectName a été ajouté à votre liste de prospection';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'new_$prospectId',
//       channelId: 'general_channel',
//     );
//   }

//   Future<void> showFollowUpNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📋 Suivi recommandé';
//     final body = 'Pensez à faire un suivi avec $prospectName';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'followup_$prospectId',
//       channelId: 'reminder_channel',
//     );
//   }

//   Future<void> showOverdueNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '⚠️ Relance en retard';
//     final body = 'La relance pour $prospectName est en retard !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'overdue_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showGroupedNotification({
//     required int count,
//     required List<String> prospectNames,
//     String? payload,
//   }) async {
//     final title = '📋 $count prospects à relancer';
//     final names = prospectNames.take(5).map((name) => '• $name').join('\n');
//     final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//     final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'group_$payload',
//       channelId: 'group_channel',
//     );
//   }
// }

// import 'dart:typed_data';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

// // ⚠️ FONCTION TOP-LEVEL pour le background (hors de la classe)
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
//   print('📱 Notification en arrière-plan reçue: ${details.payload}');

//   if (details.payload != null) {
//     _storeNotificationPayload(details.payload!);
//   }
// }

// void _storeNotificationPayload(String payload) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final notifications = prefs.getStringList('pending_notifications') ?? [];
//     if (!notifications.contains(payload)) {
//       notifications.add(payload);
//       await prefs.setStringList('pending_notifications', notifications);
//     }
//   } catch (e) {
//     print('❌ Error storing notification payload: $e');
//   }
// }

// class NotificationService {
//   NotificationService._();

//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin plugin =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   Function(String?)? _onNotificationTap;

//   // ─── Initialisation ──────────────────────────────────────────────────────

//   Future<void> initialize({Function(String?)? onNotificationTap}) async {
//     if (_isInitialized) return;

//     _onNotificationTap = onNotificationTap;

//     tz.initializeTimeZones();

//     const android = AndroidInitializationSettings('@mipmap/app_icon');

//     const ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       defaultPresentAlert: true,
//       defaultPresentBadge: true,
//       defaultPresentSound: true,
//     );

//     const settings = InitializationSettings(
//       android: android,
//       iOS: ios,
//     );

//     await plugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         _handleNotificationTap(details);
//       },
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveBackgroundNotificationResponse,
//     );

//     await _createAndroidChannels();
//     await _requestPermissions();

//     _isInitialized = true;

//     print('✅ NotificationService initialisé avec succès');
//   }

//   // ─── Canaux Android ──────────────────────────────────────────────────────

//   Future<void> _createAndroidChannels() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android == null) return;

//     final relanceChannel = AndroidNotificationChannel(
//       'relance_channel',
//       'Relances Prospect',
//       description: 'Notifications des relances de prospects',
//       importance: Importance.max,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//       playSound: true,
//       showBadge: true,
//       enableLights: true,
//     );

//     final reminderChannel = AndroidNotificationChannel(
//       'reminder_channel',
//       'Rappels',
//       description: 'Rappels des événements importants',
//       importance: Importance.high,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 300, 200, 300]),
//       showBadge: true,
//     );

//     const generalChannel = AndroidNotificationChannel(
//       'general_channel',
//       'Notifications Générales',
//       description: 'Notifications générales de l\'application',
//       importance: Importance.defaultImportance,
//     );

//     const groupChannel = AndroidNotificationChannel(
//       'group_channel',
//       'Relances Groupées',
//       description: 'Résumé des relances à effectuer',
//       importance: Importance.high,
//     );

//     await android.createNotificationChannel(relanceChannel);
//     await android.createNotificationChannel(reminderChannel);
//     await android.createNotificationChannel(generalChannel);
//     await android.createNotificationChannel(groupChannel);

//     print('✅ Canaux Android créés avec succès');
//   }

//   // ─── Permissions ──────────────────────────────────────────────────────────

//   Future<void> _requestPermissions() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android != null) {
//       await android.requestNotificationsPermission();
//     }

//     final ios = plugin.resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>();

//     if (ios != null) {
//       await ios.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     print('✅ Permissions de notification demandées');
//   }

//   // ─── Gestion des clics ────────────────────────────────────────────────────

//   void _handleNotificationTap(NotificationResponse details) {
//     final payload = details.payload;
//     print('📱 Notification cliquée: $payload');

//     if (_onNotificationTap != null) {
//       _onNotificationTap!(payload);
//     }
//   }

//   // ─── Utilitaires ──────────────────────────────────────────────────────────

//   int _getNotificationId(String prospectId) {
//     return prospectId.hashCode & 0x7fffffff;
//   }

//   NotificationDetails _getDetails(String channelId) {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         channelId,
//         channelId == 'relance_channel'
//             ? 'Relances Prospect'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels'
//                 : channelId == 'group_channel'
//                     ? 'Relances Groupées'
//                     : 'Notifications Générales',
//         channelDescription: channelId == 'relance_channel'
//             ? 'Notifications des relances de prospects'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels des événements importants'
//                 : channelId == 'group_channel'
//                     ? 'Résumé des relances à effectuer'
//                     : 'Notifications générales de l\'application',
//         importance: channelId == 'relance_channel'
//             ? Importance.max
//             : channelId == 'reminder_channel'
//                 ? Importance.high
//                 : Importance.defaultImportance,
//         priority: channelId == 'relance_channel'
//             ? Priority.high
//             : channelId == 'reminder_channel'
//                 ? Priority.max
//                 : Priority.defaultPriority,
//         enableVibration: true,
//         vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//         playSound: true,
//         styleInformation: const BigTextStyleInformation(''),
//         // ✅ PARAMÈTRES CLÉS - La notification reste jusqu'au swipe
//         autoCancel: false,           // ❌ Ne PAS s'annuler automatiquement
//         ongoing: false,              // ✅ Swipable par l'utilisateur
//         timeoutAfter: null,          // ✅ Pas de timeout
//         showWhen: true,
//         when: DateTime.now().millisecondsSinceEpoch,
//         onlyAlertOnce: false,
//         visibility: NotificationVisibility.public,
//         category: AndroidNotificationCategory.reminder,
//       ),
//       iOS: const DarwinNotificationDetails(
//         categoryIdentifier: 'relance_category',
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         interruptionLevel: InterruptionLevel.timeSensitive,
//       ),
//     );
//   }

//   // ─── Afficher une notification immédiatement ────────────────────────────

//   Future<void> showNow({
//     required String title,
//     required String body,
//     String? payload,
//     String channelId = 'general_channel',
//   }) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       await plugin.show(
//         id,
//         title,
//         body,
//         _getDetails(channelId),
//         payload: payload,
//       );

//       print('✅ Notification immédiate affichée: "$title"');
//     } catch (e) {
//       print('❌ Erreur lors de l\'affichage de la notification: $e');
//     }
//   }

//   // ─── Programmer une notification ─────────────────────────────────────────

//   Future<void> scheduleReminder({
//     required String prospectId,
//     required String prospectName,
//     required DateTime date,
//     String? comment,
//   }) async {
//     try {
//       if (date.isBefore(DateTime.now())) {
//         print('⚠️ La date de relance est déjà passée');
//         return;
//       }

//       final id = _getNotificationId(prospectId);

//       await cancelReminder(prospectId);

//       final scheduledDate = tz.TZDateTime.from(date, tz.local);

//       final title = '🔔 Relance Prospect';
//       final body = comment?.isNotEmpty == true
//           ? 'Relancer $prospectName: $comment'
//           : 'N\'oubliez pas de relancer $prospectName';

//       await plugin.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         _getDetails('relance_channel'),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: prospectId,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );

//       print('✅ Notification programmée pour $prospectName le ${date.toString()}');
//     } catch (e) {
//       print('❌ Erreur lors de la programmation: $e');
//     }
//   }

//   // ─── Programmer des notifications groupées ──────────────────────────────

//   Future<void> scheduleGroupedReminders({
//     required List<Map<String, dynamic>> prospects,
//     required DateTime date,
//   }) async {
//     try {
//       if (prospects.isEmpty) return;

//       final count = prospects.length;
//       final scheduledDate = tz.TZDateTime.from(date, tz.local);

//       if (count > 5) {
//         for (final prospect in prospects) {
//           await cancelReminder(prospect['id']);
//         }

//         final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//         final title = '📋 $count prospects à relancer';
//         final names = prospects.take(5).map((p) => '• ${p['name']}').join('\n');
//         final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//         final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//         await plugin.zonedSchedule(
//           id,
//           title,
//           body,
//           scheduledDate,
//           _getDetails('group_channel'),
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           payload: 'group_${prospects.map((p) => p['id']).join(',')}',
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//         );

//         print('✅ Notification groupée programmée pour $count prospects');
//       } else {
//         for (final prospect in prospects) {
//           await scheduleReminder(
//             prospectId: prospect['id'],
//             prospectName: prospect['name'],
//             date: date,
//             comment: prospect['comment'],
//           );
//         }
//       }
//     } catch (e) {
//       print('❌ Erreur lors de la programmation groupée: $e');
//     }
//   }

//   // ─── Annuler une notification ────────────────────────────────────────────

//   Future<void> cancelReminder(String prospectId) async {
//     try {
//       final id = _getNotificationId(prospectId);
//       await plugin.cancel(id);
//       print('✅ Notification annulée pour le prospect $prospectId');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Annuler toutes les notifications ────────────────────────────────────

//   Future<void> cancelAll() async {
//     try {
//       await plugin.cancelAll();
//       print('✅ Toutes les notifications ont été annulées');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Récupérer les notifications en attente ─────────────────────────────

//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     try {
//       return await plugin.pendingNotificationRequests();
//     } catch (e) {
//       print('❌ Erreur lors de la récupération des notifications: $e');
//       return [];
//     }
//   }

//   // ─── Vérifier si une notification est programmée ─────────────────────────

//   Future<bool> isNotificationScheduled(String prospectId) async {
//     try {
//       final pending = await getPendingNotifications();
//       final id = _getNotificationId(prospectId);
//       return pending.any((n) => n.id == id);
//     } catch (e) {
//       return false;
//     }
//   }

//   // ─── Notifications spécifiques ───────────────────────────────────────────

//   Future<void> showRelanceNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '🔔 Relance recommandée';
//     final body = 'Le prospect $prospectName devrait être relancé aujourd\'hui !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'relance_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showNewProspectNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📝 Nouveau Prospect';
//     final body = '$prospectName a été ajouté à votre liste de prospection';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'new_$prospectId',
//       channelId: 'general_channel',
//     );
//   }

//   Future<void> showFollowUpNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📋 Suivi recommandé';
//     final body = 'Pensez à faire un suivi avec $prospectName';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'followup_$prospectId',
//       channelId: 'reminder_channel',
//     );
//   }

//   Future<void> showOverdueNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '⚠️ Relance en retard';
//     final body = 'La relance pour $prospectName est en retard !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'overdue_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showGroupedNotification({
//     required int count,
//     required List<String> prospectNames,
//     String? payload,
//   }) async {
//     final title = '📋 $count prospects à relancer';
//     final names = prospectNames.take(5).map((name) => '• $name').join('\n');
//     final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//     final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'group_$payload',
//       channelId: 'group_channel',
//     );
//   }
// }

//////////////////////////////////////////////////////////////
library;

/// PROSPECT OF THE DAY

////////////////////////////////////////////////////////////////
///
// ///

// import 'dart:typed_data';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

// // ⚠️ FONCTION TOP-LEVEL pour le background (hors de la classe)
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
//   print('📱 Notification en arrière-plan reçue: ${details.payload}');

//   if (details.payload != null) {
//     _storeNotificationPayload(details.payload!);
//   }
// }

// void _storeNotificationPayload(String payload) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final notifications = prefs.getStringList('pending_notifications') ?? [];
//     if (!notifications.contains(payload)) {
//       notifications.add(payload);
//       await prefs.setStringList('pending_notifications', notifications);
//     }
//   } catch (e) {
//     print('❌ Error storing notification payload: $e');
//   }
// }

// class NotificationService {
//   NotificationService._();

//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin plugin =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   Function(String?)? _onNotificationTap;

//   // ─── Initialisation ──────────────────────────────────────────────────────

//   Future<void> initialize({Function(String?)? onNotificationTap}) async {
//     if (_isInitialized) return;

//     _onNotificationTap = onNotificationTap;

//     tz.initializeTimeZones();

//     const android = AndroidInitializationSettings('@mipmap/app_icon');

//     const ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       defaultPresentAlert: true,
//       defaultPresentBadge: true,
//       defaultPresentSound: true,
//     );

//     const settings = InitializationSettings(
//       android: android,
//       iOS: ios,
//     );

//     await plugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         _handleNotificationTap(details);
//       },
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveBackgroundNotificationResponse,
//     );

//     await _createAndroidChannels();
//     await _requestPermissions();

//     _isInitialized = true;

//     print('✅ NotificationService initialisé avec succès');
//   }

//   // ─── Canaux Android ──────────────────────────────────────────────────────

//   Future<void> _createAndroidChannels() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android == null) return;

//     final relanceChannel = AndroidNotificationChannel(
//       'relance_channel',
//       'Relances Prospect',
//       description: 'Notifications des relances de prospects',
//       importance: Importance.max,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//       playSound: true,
//       showBadge: true,
//       enableLights: true,
//     );

//     final reminderChannel = AndroidNotificationChannel(
//       'reminder_channel',
//       'Rappels',
//       description: 'Rappels des événements importants',
//       importance: Importance.high,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList([0, 300, 200, 300]),
//       showBadge: true,
//     );

//     const generalChannel = AndroidNotificationChannel(
//       'general_channel',
//       'Notifications Générales',
//       description: 'Notifications générales de l\'application',
//       importance: Importance.defaultImportance,
//     );

//     const groupChannel = AndroidNotificationChannel(
//       'group_channel',
//       'Relances Groupées',
//       description: 'Résumé des relances à effectuer',
//       importance: Importance.high,
//     );

//     await android.createNotificationChannel(relanceChannel);
//     await android.createNotificationChannel(reminderChannel);
//     await android.createNotificationChannel(generalChannel);
//     await android.createNotificationChannel(groupChannel);

//     print('✅ Canaux Android créés avec succès');
//   }

//   // ─── Permissions ──────────────────────────────────────────────────────────

//   Future<void> _requestPermissions() async {
//     final android = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();

//     if (android != null) {
//       await android.requestNotificationsPermission();
//     }

//     final ios = plugin.resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>();

//     if (ios != null) {
//       await ios.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     print('✅ Permissions de notification demandées');
//   }

//   // ─── Gestion des clics ────────────────────────────────────────────────────

//   void _handleNotificationTap(NotificationResponse details) {
//     final payload = details.payload;
//     print('📱 Notification cliquée: $payload');

//     if (_onNotificationTap != null) {
//       _onNotificationTap!(payload);
//     }
//   }

//   // ─── Utilitaires ──────────────────────────────────────────────────────────

//   int _getNotificationId(String prospectId) {
//     return prospectId.hashCode & 0x7fffffff;
//   }

//   int _getGroupNotificationId(DateTime date) {
//     final key = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
//     return key.hashCode & 0x7fffffff;
//   }

//   NotificationDetails _getDetails(String channelId) {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         channelId,
//         channelId == 'relance_channel'
//             ? 'Relances Prospect'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels'
//                 : channelId == 'group_channel'
//                     ? 'Relances Groupées'
//                     : 'Notifications Générales',
//         channelDescription: channelId == 'relance_channel'
//             ? 'Notifications des relances de prospects'
//             : channelId == 'reminder_channel'
//                 ? 'Rappels des événements importants'
//                 : channelId == 'group_channel'
//                     ? 'Résumé des relances à effectuer'
//                     : 'Notifications générales de l\'application',
//         importance: channelId == 'relance_channel'
//             ? Importance.max
//             : channelId == 'reminder_channel'
//                 ? Importance.high
//                 : Importance.defaultImportance,
//         priority: channelId == 'relance_channel'
//             ? Priority.high
//             : channelId == 'reminder_channel'
//                 ? Priority.max
//                 : Priority.defaultPriority,
//         enableVibration: true,
//         vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
//         playSound: true,
//         styleInformation: const BigTextStyleInformation(''),
//         autoCancel: false,
//         ongoing: false,
//         timeoutAfter: null,
//         showWhen: true,
//         when: DateTime.now().millisecondsSinceEpoch,
//         onlyAlertOnce: false,
//         visibility: NotificationVisibility.public,
//         category: AndroidNotificationCategory.reminder,
//       ),
//       iOS: const DarwinNotificationDetails(
//         categoryIdentifier: 'relance_category',
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         interruptionLevel: InterruptionLevel.timeSensitive,
//       ),
//     );
//   }

//   // ─── Afficher une notification immédiatement ────────────────────────────

//   Future<void> showNow({
//     required String title,
//     required String body,
//     String? payload,
//     String channelId = 'general_channel',
//   }) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       await plugin.show(
//         id,
//         title,
//         body,
//         _getDetails(channelId),
//         payload: payload,
//       );

//       print('✅ Notification immédiate affichée: "$title"');
//     } catch (e) {
//       print('❌ Erreur lors de l\'affichage de la notification: $e');
//     }
//   }

//   // ─── Programmer une notification individuelle ───────────────────────────

//   Future<void> scheduleReminder({
//     required String prospectId,
//     required String prospectName,
//     required DateTime date,
//     String? comment,
//   }) async {
//     try {
//       if (date.isBefore(DateTime.now())) {
//         print('⚠️ La date de relance est déjà passée');
//         return;
//       }

//       final id = _getNotificationId(prospectId);

//       await cancelReminder(prospectId);

//       final scheduledDate = tz.TZDateTime.from(date, tz.local);

//       final title = '🔔 Relance Prospect';
//       final body = comment?.isNotEmpty == true
//           ? 'Relancer $prospectName: $comment'
//           : 'N\'oubliez pas de relancer $prospectName';

//       await plugin.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         _getDetails('relance_channel'),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: prospectId,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );

//       print('✅ Notification programmée pour $prospectName le ${date.toString()}');
//     } catch (e) {
//       print('❌ Erreur lors de la programmation: $e');
//     }
//   }

//   // ─── Programmer des notifications groupées par date ──────────────────────

//   /// Programme une notification groupée pour tous les prospects ayant la même date de relance
//   Future<void> scheduleGroupedRemindersByDate({
//     required List<Map<String, dynamic>> prospects,
//     required DateTime date,
//   }) async {
//     try {
//       if (prospects.isEmpty) return;

//       final count = prospects.length;
//       final dateKey = DateTime(date.year, date.month, date.day);
//       final scheduledDate = tz.TZDateTime.from(date, tz.local);
//       final groupId = _getGroupNotificationId(dateKey);

//       // ✅ ANNULER LA NOTIFICATION GROUPÉE PRÉCÉDENTE POUR CETTE DATE
//       await plugin.cancel(groupId);

//       // ✅ TITRE ET CORPS DE LA NOTIFICATION GROUPÉE
//       final title = '📋 $count prospects à relancer aujourd\'hui';

//       // Afficher les 5 premiers noms
//       final names = prospects.take(5).map((p) => '• ${p['name']}').join('\n');
//       final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//       final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//       // ✅ PROGRAMMER LA NOTIFICATION GROUPÉE
//       await plugin.zonedSchedule(
//         groupId,
//         title,
//         body,
//         scheduledDate,
//         _getDetails('group_channel'),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: 'group_${dateKey.toIso8601String()}_${prospects.map((p) => p['id']).join(',')}',
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );

//       print('✅ Notification groupée programmée pour $count prospects le ${dateKey.toIso8601String()}');

//     } catch (e) {
//       print('❌ Erreur lors de la programmation groupée: $e');
//     }
//   }

//   // ─── Programme des notifications en regroupant par date ──────────────────

//   /// Prend une liste de prospects et les regroupe par date avant de programmer une notification par date
//   Future<void> scheduleRemindersGroupedByDate({
//     required List<Map<String, dynamic>> prospects,
//   }) async {
//     try {
//       if (prospects.isEmpty) return;

//       // ✅ Grouper les prospects par date (uniquement la date, sans l'heure)
//       final Map<String, List<Map<String, dynamic>>> groupedByDate = {};

//       for (final prospect in prospects) {
//         final date = prospect['date'] as DateTime;
//         final dateKey = DateTime(date.year, date.month, date.day).toIso8601String();

//         groupedByDate.putIfAbsent(dateKey, () => []).add(prospect);
//       }

//       // ✅ Pour chaque groupe de date, programmer une notification groupée
//       for (final entry in groupedByDate.entries) {
//         final dateKey = entry.key;
//         final date = DateTime.parse(dateKey);
//         final prospectsForDate = entry.value;

//         // Si moins de 3 prospects pour cette date, programmer individuellement
//         if (prospectsForDate.length < 3) {
//           for (final prospect in prospectsForDate) {
//             await scheduleReminder(
//               prospectId: prospect['id'],
//               prospectName: prospect['name'],
//               date: prospect['date'],
//               comment: prospect['comment'],
//             );
//           }
//         } else {
//           // Sinon, programmer une notification groupée
//           await scheduleGroupedRemindersByDate(
//             prospects: prospectsForDate,
//             date: date,
//           );
//         }
//       }

//       print('✅ ${groupedByDate.length} notifications groupées programmées');

//     } catch (e) {
//       print('❌ Erreur lors de la programmation groupée: $e');
//     }
//   }

//   // ─── Annuler les notifications d'une date spécifique ────────────────────

//   Future<void> cancelGroupedReminder(DateTime date) async {
//     try {
//       final groupId = _getGroupNotificationId(date);
//       await plugin.cancel(groupId);
//       print('✅ Notification groupée annulée pour ${date.toIso8601String()}');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Annuler une notification ────────────────────────────────────────────

//   Future<void> cancelReminder(String prospectId) async {
//     try {
//       final id = _getNotificationId(prospectId);
//       await plugin.cancel(id);
//       print('✅ Notification annulée pour le prospect $prospectId');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Annuler toutes les notifications ────────────────────────────────────

//   Future<void> cancelAll() async {
//     try {
//       await plugin.cancelAll();
//       print('✅ Toutes les notifications ont été annulées');
//     } catch (e) {
//       print('❌ Erreur lors de l\'annulation: $e');
//     }
//   }

//   // ─── Récupérer les notifications en attente ─────────────────────────────

//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     try {
//       return await plugin.pendingNotificationRequests();
//     } catch (e) {
//       print('❌ Erreur lors de la récupération des notifications: $e');
//       return [];
//     }
//   }

//   // ─── Vérifier si une notification est programmée ─────────────────────────

//   Future<bool> isNotificationScheduled(String prospectId) async {
//     try {
//       final pending = await getPendingNotifications();
//       final id = _getNotificationId(prospectId);
//       return pending.any((n) => n.id == id);
//     } catch (e) {
//       return false;
//     }
//   }

//   // ─── Notifications spécifiques ───────────────────────────────────────────

//   Future<void> showRelanceNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '🔔 Relance recommandée';
//     final body = 'Le prospect $prospectName devrait être relancé aujourd\'hui !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'relance_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showNewProspectNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📝 Nouveau Prospect';
//     final body = '$prospectName a été ajouté à votre liste de prospection';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'new_$prospectId',
//       channelId: 'general_channel',
//     );
//   }

//   Future<void> showFollowUpNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '📋 Suivi recommandé';
//     final body = 'Pensez à faire un suivi avec $prospectName';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'followup_$prospectId',
//       channelId: 'reminder_channel',
//     );
//   }

//   Future<void> showOverdueNotification({
//     required String prospectName,
//     String? prospectId,
//   }) async {
//     const title = '⚠️ Relance en retard';
//     final body = 'La relance pour $prospectName est en retard !';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'overdue_$prospectId',
//       channelId: 'relance_channel',
//     );
//   }

//   Future<void> showGroupedNotification({
//     required int count,
//     required List<String> prospectNames,
//     String? payload,
//   }) async {
//     final title = '📋 $count prospects à relancer';
//     final names = prospectNames.take(5).map((name) => '• $name').join('\n');
//     final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
//     final body = 'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

//     await showNow(
//       title: title,
//       body: body,
//       payload: 'group_$payload',
//       channelId: 'group_channel',
//     );
//   }
// }

import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// ⚠️ FONCTION TOP-LEVEL pour le background (hors de la classe)
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
  print('📱 Notification en arrière-plan reçue: ${details.payload}');

  if (details.payload != null) {
    _storeNotificationPayload(details.payload!);
  }
}

void _storeNotificationPayload(String payload) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('pending_notifications') ?? [];
    if (!notifications.contains(payload)) {
      notifications.add(payload);
      await prefs.setStringList('pending_notifications', notifications);
    }
  } catch (e) {
    print('❌ Error storing notification payload: $e');
  }
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Function(String?)? _onNotificationTap;

  // ─── Initialisation ──────────────────────────────────────────────────────

  Future<void> initialize({Function(String?)? onNotificationTap}) async {
    if (_isInitialized) return;

    _onNotificationTap = onNotificationTap;

    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/app_icon');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap(details);
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    await _createAndroidChannels();
    await _requestPermissions();

    _isInitialized = true;

    print('✅ NotificationService initialisé avec succès');
  }

  // ─── Canaux Android ──────────────────────────────────────────────────────

  Future<void> _createAndroidChannels() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    final relanceChannel = AndroidNotificationChannel(
      'relance_channel',
      'Relances Prospect',
      description: 'Notifications des relances de prospects',
      importance: Importance.max,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      playSound: true,
      showBadge: true,
      enableLights: true,
    );

    final reminderChannel = AndroidNotificationChannel(
      'reminder_channel',
      'Rappels',
      description: 'Rappels des événements importants',
      importance: Importance.high,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 300, 200, 300]),
      showBadge: true,
    );

    const generalChannel = AndroidNotificationChannel(
      'general_channel',
      'Notifications Générales',
      description: 'Notifications générales de l\'application',
      importance: Importance.defaultImportance,
    );

    const groupChannel = AndroidNotificationChannel(
      'group_channel',
      'Relances Groupées',
      description: 'Résumé des relances à effectuer',
      importance: Importance.high,
    );

    await android.createNotificationChannel(relanceChannel);
    await android.createNotificationChannel(reminderChannel);
    await android.createNotificationChannel(generalChannel);
    await android.createNotificationChannel(groupChannel);

    print('✅ Canaux Android créés avec succès');
  }

  // ─── Permissions ──────────────────────────────────────────────────────────

  Future<void> _requestPermissions() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    print('✅ Permissions de notification demandées');
  }

  // ─── Gestion des clics ────────────────────────────────────────────────────

  void _handleNotificationTap(NotificationResponse details) {
    final payload = details.payload;
    print('📱 Notification cliquée: $payload');

    if (_onNotificationTap != null) {
      _onNotificationTap!(payload);
    }
  }

  // ─── Utilitaires ──────────────────────────────────────────────────────────

  int _getNotificationId(String prospectId) {
    return prospectId.hashCode & 0x7fffffff;
  }

  int _getGroupNotificationId(DateTime date) {
    final key =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return key.hashCode & 0x7fffffff;
  }

  NotificationDetails _getDetails(String channelId) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId == 'relance_channel'
            ? 'Relances Prospect'
            : channelId == 'reminder_channel'
                ? 'Rappels'
                : channelId == 'group_channel'
                    ? 'Relances Groupées'
                    : 'Notifications Générales',
        channelDescription: channelId == 'relance_channel'
            ? 'Notifications des relances de prospects'
            : channelId == 'reminder_channel'
                ? 'Rappels des événements importants'
                : channelId == 'group_channel'
                    ? 'Résumé des relances à effectuer'
                    : 'Notifications générales de l\'application',
        importance: channelId == 'relance_channel'
            ? Importance.max
            : channelId == 'reminder_channel'
                ? Importance.high
                : Importance.defaultImportance,
        priority: channelId == 'relance_channel'
            ? Priority.high
            : channelId == 'reminder_channel'
                ? Priority.max
                : Priority.defaultPriority,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
        playSound: true,
        styleInformation: const BigTextStyleInformation(''),
        autoCancel: false,
        ongoing: false,
        timeoutAfter: null,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        onlyAlertOnce: false,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        categoryIdentifier: 'relance_category',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

  // ─── Afficher une notification immédiatement ────────────────────────────

  Future<void> showNow({
    required String title,
    required String body,
    String? payload,
    String channelId = 'general_channel',
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await plugin.show(
        id,
        title,
        body,
        _getDetails(channelId),
        payload: payload,
      );

      print('✅ Notification immédiate affichée: "$title"');
    } catch (e) {
      print('❌ Erreur lors de l\'affichage de la notification: $e');
    }
  }

  // ─── Programmer une notification individuelle ───────────────────────────

  // Future<void> scheduleReminder({
  //   required String prospectId,
  //   required String prospectName,
  //   required DateTime date,
  //   String? comment,
  // }) async {
  //   try {
  //     if (date.isBefore(DateTime.now())) {
  //       print('⚠️ La date de relance est déjà passée');
  //       return;
  //     }

  //     final id = _getNotificationId(prospectId);

  //     await cancelReminder(prospectId);

  //     final scheduledDate = tz.TZDateTime.from(date, tz.local);

  //     const title = '🔔 Relance Prospect';
  //     final body = comment?.isNotEmpty == true
  //         ? 'Relancer $prospectName: $comment'
  //         : 'N\'oubliez pas de relancer $prospectName';

  //     await plugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       scheduledDate,
  //       _getDetails('relance_channel'),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       payload: prospectId,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );

  //     print('✅ Notification programmée pour $prospectName le ${date.toString()}');
  //   } catch (e) {
  //     print('❌ Erreur lors de la programmation: $e');
  //   }
  // }

  Future<void> scheduleReminder({
    required String prospectId,
    required String prospectName,
    required DateTime date,
    String? comment,
  }) async {
    try {
      // ✅ Ajouter une marge de sécurité de 1 minute
      final minFutureDate = DateTime.now().add(const Duration(minutes: 1));

      if (date.isBefore(minFutureDate)) {
        print(
            '⚠️ La date de relance est trop proche ou passée (min: $minFutureDate)');

        // ✅ Si la date est dans le futur mais trop proche, on la décale de 1 minute
        if (date.isAfter(DateTime.now())) {
          final adjustedDate = date.add(const Duration(minutes: 1));
          print('📅 Date ajustée à $adjustedDate');
          date = adjustedDate;
        } else {
          return;
        }
      }

      final id = _getNotificationId(prospectId);

      await cancelReminder(prospectId);

      final scheduledDate = tz.TZDateTime.from(date, tz.local);

      const title = '🔔 Relance Prospect';
      final body = comment?.isNotEmpty == true
          ? 'Relancer $prospectName: $comment'
          : 'N\'oubliez pas de relancer $prospectName';

      await plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _getDetails('relance_channel'),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: prospectId,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(
          '✅ Notification programmée pour $prospectName le ${date.toString()}');
    } catch (e) {
      print('❌ Erreur lors de la programmation: $e');
    }
  }
  // ─── Programmer des notifications groupées par date ──────────────────────

  Future<void> scheduleGroupedRemindersByDate({
    required List<Map<String, dynamic>> prospects,
    required DateTime date,
  }) async {
    try {
      if (prospects.isEmpty) return;

      final count = prospects.length;
      final dateKey = DateTime(date.year, date.month, date.day);
      final scheduledDate = tz.TZDateTime.from(date, tz.local);
      final groupId = _getGroupNotificationId(dateKey);

      await plugin.cancel(groupId);

      final title = '📋 $count prospects à relancer aujourd\'hui';

      final names = prospects.take(5).map((p) => '• ${p['name']}').join('\n');
      final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
      final body =
          'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

      await plugin.zonedSchedule(
        groupId,
        title,
        body,
        scheduledDate,
        _getDetails('group_channel'),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload:
            'group_${dateKey.toIso8601String()}_${prospects.map((p) => p['id']).join(',')}',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(
          '✅ Notification groupée programmée pour $count prospects le ${dateKey.toIso8601String()}');
    } catch (e) {
      print('❌ Erreur lors de la programmation groupée: $e');
    }
  }

  // ─── Programme des notifications en regroupant par date ──────────────────

  Future<void> scheduleRemindersGroupedByDate({
    required List<Map<String, dynamic>> prospects,
  }) async {
    try {
      if (prospects.isEmpty) return;

      // Grouper les prospects par date
      final Map<String, List<Map<String, dynamic>>> groupedByDate = {};

      for (final prospect in prospects) {
        final date = prospect['date'] as DateTime;
        final dateKey =
            DateTime(date.year, date.month, date.day).toIso8601String();
        groupedByDate.putIfAbsent(dateKey, () => []).add(prospect);
      }

      // Pour chaque groupe de date
      for (final entry in groupedByDate.entries) {
        final dateKey = entry.key;
        final date = DateTime.parse(dateKey);
        final prospectsForDate = entry.value;

        // Si moins de 3 prospects, notifications individuelles
        if (prospectsForDate.length < 3) {
          for (final prospect in prospectsForDate) {
            await scheduleReminder(
              prospectId: prospect['id'],
              prospectName: prospect['name'],
              date: prospect['date'],
              comment: prospect['comment'],
            );
          }
        } else {
          // Sinon notification groupée
          await scheduleGroupedRemindersByDate(
            prospects: prospectsForDate,
            date: date,
          );
        }
      }

      print('✅ ${groupedByDate.length} notifications groupées programmées');
    } catch (e) {
      print('❌ Erreur lors de la programmation groupée: $e');
    }
  }

  // ─── Annuler les notifications d'une date spécifique ────────────────────

  Future<void> cancelGroupedReminder(DateTime date) async {
    try {
      final groupId = _getGroupNotificationId(date);
      await plugin.cancel(groupId);
      print('✅ Notification groupée annulée pour ${date.toIso8601String()}');
    } catch (e) {
      print('❌ Erreur lors de l\'annulation: $e');
    }
  }

  // ─── Annuler une notification ────────────────────────────────────────────

  Future<void> cancelReminder(String prospectId) async {
    try {
      final id = _getNotificationId(prospectId);
      await plugin.cancel(id);
      print('✅ Notification annulée pour le prospect $prospectId');
    } catch (e) {
      print('❌ Erreur lors de l\'annulation: $e');
    }
  }

  // ─── Annuler toutes les notifications ────────────────────────────────────

  Future<void> cancelAll() async {
    try {
      await plugin.cancelAll();
      print('✅ Toutes les notifications ont été annulées');
    } catch (e) {
      print('❌ Erreur lors de l\'annulation: $e');
    }
  }

  // ─── Récupérer les notifications en attente ─────────────────────────────

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await plugin.pendingNotificationRequests();
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications: $e');
      return [];
    }
  }

  // ─── Vérifier si une notification est programmée ─────────────────────────

  Future<bool> isNotificationScheduled(String prospectId) async {
    try {
      final pending = await getPendingNotifications();
      final id = _getNotificationId(prospectId);
      return pending.any((n) => n.id == id);
    } catch (e) {
      return false;
    }
  }

  // ─── Notifications spécifiques ───────────────────────────────────────────

  Future<void> showRelanceNotification({
    required String prospectName,
    String? prospectId,
  }) async {
    const title = '🔔 Relance recommandée';
    final body =
        'Le prospect $prospectName devrait être relancé aujourd\'hui !';

    await showNow(
      title: title,
      body: body,
      payload: 'relance_$prospectId',
      channelId: 'relance_channel',
    );
  }

  Future<void> showNewProspectNotification({
    required String prospectName,
    String? prospectId,
  }) async {
    const title = '📝 Nouveau Prospect';
    final body = '$prospectName a été ajouté à votre liste de prospection';

    await showNow(
      title: title,
      body: body,
      payload: 'new_$prospectId',
      channelId: 'general_channel',
    );
  }

  Future<void> showFollowUpNotification({
    required String prospectName,
    String? prospectId,
  }) async {
    const title = '📋 Suivi recommandé';
    final body = 'Pensez à faire un suivi avec $prospectName';

    await showNow(
      title: title,
      body: body,
      payload: 'followup_$prospectId',
      channelId: 'reminder_channel',
    );
  }

  Future<void> showOverdueNotification({
    required String prospectName,
    String? prospectId,
  }) async {
    const title = '⚠️ Relance en retard';
    final body = 'La relance pour $prospectName est en retard !';

    await showNow(
      title: title,
      body: body,
      payload: 'overdue_$prospectId',
      channelId: 'relance_channel',
    );
  }

  Future<void> showGroupedNotification({
    required int count,
    required List<String> prospectNames,
    String? payload,
  }) async {
    final title = '📋 $count prospects à relancer';
    final names = prospectNames.take(5).map((name) => '• $name').join('\n');
    final remaining = count > 5 ? '\n... et ${count - 5} autres' : '';
    final body =
        'Vous avez $count prospects à relancer aujourd\'hui :\n$names$remaining';

    await showNow(
      title: title,
      body: body,
      payload: 'group_$payload',
      channelId: 'group_channel',
    );
  }
}
