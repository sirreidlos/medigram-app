import 'package:flutter/material.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/utils/style.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(screenPadding),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consultations History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            // RecordCard(),
            // RecordCard()
          ],
        )
      )
    );
  }}