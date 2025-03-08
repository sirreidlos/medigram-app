import 'package:flutter/material.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/utils/style.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ConsultForm extends StatelessWidget {
  const ConsultForm(this.barcode, {super.key});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          screenPadding,
          topScreenPadding,
          screenPadding,
          screenPadding,
        ),
        child: Column(
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                Text(
                  "Prescription Form",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Input(
              header: "Name",
              placeholder: "Input your name",
              initValue: "Jane Doe",
              isDisabled: true,
              iconVerified: true,
            ),
            LineDivider(),
            Input(
              header: "Name",
              placeholder: "Input your name",
              initValue: "Jane Doe",
              isDisabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
