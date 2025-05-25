import 'package:flutter/material.dart';
import 'package:medigram_app/components/history.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/constants/style.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
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
            children: [
              PopupHeader(context, "Medication Reminder"),
              Text(
                        "Setup your new regimen",
                        style: header2,
                      ),
              RecordHistory(isPatient: true, topN: false, isReminder: true),
              Text(
                        "Your ongoing regimen",
                        style: header2,
                      ),
              RecordHistory(isPatient: true, topN: false, isReminder: false),
            ],
          ),
        ),
      ),
    );
  }
  
}


