import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService instance = NotificationService.internal();

  factory NotificationService() {
    return instance;
  }

  NotificationService.internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // final String currentTimeZone = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    await notificationsPlugin.initialize(initializationSettings);
  }

  List<DateTime> generateReminderSchedule(
    DateTime startDate,
    Prescription prescription,
  ) {
    List<DateTime> reminders = [];

    int totalDays = (prescription.quantityPerDose / prescription.regimenPerDay)
        .ceil();

    for (int day = 0; day < totalDays; day++) {
      for (int i = 0; i < prescription.regimenPerDay; i++) {
        DateTime reminderTime = startDate.add(Duration(
          days: day,
          hours: (24 ~/ prescription.regimenPerDay) * i,
        ));
        reminders.add(reminderTime);
      }
    }

    return reminders;
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleNotification(
      int id, String title, String body, TZDateTime scheduledTime) async {
    try {
      await notificationsPlugin.zonedSchedule(
        0,
        "notification title",
        "notification body",
        scheduledTime,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> scheduleAllNotification(
      DateTime startTime, List<Prescription> prescriptions) async {
    int notificationId = 0;
    for (final prescription in prescriptions) {
      final schedule = generateReminderSchedule(startTime, prescription);
      for (var time in schedule) {
        debugPrint(time.toString());
        if (time.isBefore(DateTime.now())) {
          time = time.add(const Duration(minutes: 1));
        }
        final tz.TZDateTime scheduledTime = tz.TZDateTime.from(time, tz.local);
        await scheduleNotification(
          notificationId++,
          'Take ${prescription.drugName}',
          '${prescription.dosesInMg} mg - ${prescription.instruction}',
          scheduledTime,
        );
      }
    }
  }
}
