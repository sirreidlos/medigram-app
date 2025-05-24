import 'package:flutter/material.dart';
import 'package:medigram_app/components/history.dart';
import 'package:medigram_app/constants/style.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            screenPadding,
            topScreenPadding,
            screenPadding,
            screenPadding,
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Consultations History", style: header2),
              RecordHistory(true, false) // TODO Save user current status (doctor or patient)
            ],
          ),
        ),
      ),
    );
  }
}
