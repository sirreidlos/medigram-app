import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/scan_qr.dart';
import 'package:medigram_app/components/show_qr.dart';
import 'package:medigram_app/page/form.dart';
import 'package:medigram_app/utils/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String uniqueCode = "12345";
  final bool isPatient = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(screenPadding, topScreenPadding, screenPadding, screenPadding),
              decoration: BoxDecoration(
                color: Color(secondaryColor1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                spacing: 30,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hello, ${isPatient ? "" : "Dr. "} Jane Doe",
                        style: title,
                      ),
                      Spacer(),
                      Icon(Icons.swap_horiz_rounded),
                      Icon(Icons.notifications),
                    ],
                  ),
                  mainFeature(context, uniqueCode, isPatient),
                  isPatient ? medsHandler(context, uniqueCode) : Container(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenPadding),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Consultations",
                    style: header2,
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                  RecordCard(
                    title: "ABCDE",
                    subtitle: "123 abcdefghjik",
                    info1: "00/00/00",
                    info2: "12:22",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget mainFeature(BuildContext context, String uniqueCode, bool isPatient) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        if (isPatient) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                return ShowQr(uniqueCode, true);
              }),
            ),
          );
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                // return ScanQR();
                return ConsultForm("123");
              }),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(primaryColor1),
        padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isPatient ? "Start Consultation" : "Scan Patient Data",
        style: header1,
      ),
    ),
  );
}

Widget medsHandler(BuildContext context, String uniqueCode) {
  return Row(
    spacing: 20,
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return ShowQr(uniqueCode, false); //TODO: Change into button NOT qr code
                }),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(primaryColor2),
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Meds Claim",
            style: header1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(secondaryColor2),
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Meds Regimen",
            style: header1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
