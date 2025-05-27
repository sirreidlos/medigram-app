import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:medigram_app/page/splash_screen.dart';
import 'package:medigram_app/services/notification_service.dart';
import 'package:medigram_app/services/reminder_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().init();
  runApp(const MyApp());
}

// Future<void> checkExactAlarmPermission() async {
//   if (Platform.isAndroid) {
//     final deviceInfo = DeviceInfoPlugin();
//     final androidInfo = await deviceInfo.androidInfo;
//     final sdkInt = androidInfo.version.sdkInt;

//     if (sdkInt >= 31) {
//       final intent = AndroidIntent(
//         action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
//         flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//       );
//       await intent.launch();
//     }
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medigram',
      home: const SplashScreen(),
    );
  }
}
