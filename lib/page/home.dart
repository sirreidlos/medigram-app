import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medigram_app/components/history.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/scan_qr.dart';
import 'package:medigram_app/components/show_qr.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/nonce.dart';
import 'package:medigram_app/models/user/user.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/form.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/nonce_service.dart';
import 'package:medigram_app/services/user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.isPatient, {super.key});

  final bool isPatient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                screenPadding,
                topScreenPadding,
                screenPadding,
                screenPadding,
              ),
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
                        "Hello, ${isPatient ? "" : "Dr. "}Jane Doe", //TODO Change to dynamic data
                        style: title,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.swap_horiz_rounded),
                        onPressed: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BottomNavigationMenu(!isPatient)))
                        },
                      ),
                      Icon(Icons.notifications),
                    ],
                  ),
                  mainFeature(context, isPatient),
                  isPatient ? medsHandler(context) : Container(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenPadding),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Consultations", style: header2),
                  RecordHistory(isPatient, true)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget mainFeature(BuildContext context, bool isPatient) {
  return Column(
    spacing: isPatient ? 0 : 10,
    children: [
      isPatient
          ? SizedBox(
              height: 0,
            )
          : Row(children: [
              Icon(Icons.location_on),
              Text("Practice Address",
                  style: title) //TODO Change to dynamic data
            ]),
      SizedBox(
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          onPressed: () async {
            if (isPatient) {
              final response = await NonceService().requestNonce();
              // TODO error handle, show toast or something if it's not 200 OK
              Map<String, dynamic> data = jsonDecode(response.body);
              Nonce nonce = Nonce.fromJson(data); // get code from data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    return ShowQr(nonce, true);
                  }),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    // return ScanQR();
                    return ConsultForm(
                        "abcde"); // TODO: Dev only, uncomment above code
                  }),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(primaryColor1),
            padding: EdgeInsets.all(screenPadding),
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            spacing: screenPadding,
            children: [
              Image.asset(
                'assets/icons/start-consultation.png',
                width: 50,
              ),
              Text(
                isPatient ? "Start Consultation" : "Scan Patient Data",
                style: header1,
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Widget medsHandler(BuildContext context) {
  return Row(
    spacing: 20,
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () async {
            final response = await NonceService().requestNonce();
            // TODO error handle, show toast or something if it's not 200 OK
            Map<String, dynamic> data = jsonDecode(response.body);
            Nonce nonce = Nonce.fromJson(data); // get code from data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return ShowQr(
                    nonce,
                    false,
                  ); //TODO: Change into button NOT qr code
                }),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(primaryColor2),
            padding: EdgeInsets.all(screenPadding),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            spacing: 10,
            children: [
              Image.asset(
                'assets/icons/meds-claim.png',
                width: 50,
              ),
              Text(
                "Meds Claim",
                style: header1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(secondaryColor2),
            padding: EdgeInsets.only(
                left: screenPadding - 5,
                right: screenPadding - 5,
                top: screenPadding,
                bottom: screenPadding),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            spacing: 10,
            children: [
              Image.asset(
                'assets/icons/meds-regiment.png',
                width: 50,
              ),
              Text(
                "Meds Regiment",
                style: header1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
