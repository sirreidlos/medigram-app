import 'dart:ui';

import 'package:medigram_app/models/consultation/consultation.dart';

class ConsultationDetail {
  final Consultation consultation;
  final String title;
  final String practiceAddress;
  final VoidCallback onPressed;

  ConsultationDetail({
    required this.consultation,
    required this.title,
    required this.practiceAddress,
    required this.onPressed,
  });
}