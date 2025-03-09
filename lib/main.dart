import 'package:flutter/material.dart';
import 'package:medigram_app/page/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

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

