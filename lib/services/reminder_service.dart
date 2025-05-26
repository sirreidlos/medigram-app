import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  List<DateTime> generateReminderSchedule(
    DateTime startDate,
    Prescription prescription,
  ) {
    List<DateTime> reminders = [];

    int totalDays =
        (prescription.quantityPerDose / prescription.regimenPerDay).ceil(); // TODO Check if double

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

  Future<void> scheduleAllReminders(
      DateTime startTime, List<Prescription> prescriptions) async {
    int notificationId = 0;
    for (final prescription in prescriptions) {
      final schedule = generateReminderSchedule(startTime, prescription);
      for (final time in schedule) {
        await scheduleNotification(
          notificationId++,
          'Take ${prescription.drugName}',
          '${prescription.dosesInMg} mg - ${prescription.instruction}',
          time,
        );
      }
    }
  }
}
