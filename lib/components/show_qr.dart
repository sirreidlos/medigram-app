import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/utils/qr_image.dart';
import 'package:medigram_app/constants/style.dart';

class ShowQr extends StatelessWidget {
  const ShowQr(this.uniqueCode, this.isConsult, {super.key});

  final String uniqueCode;
  final bool isConsult;

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
                children: [
                  PopupHeader(
                    context,
                    isConsult ? "Consultation" : "Medicine Claim",
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: screenPadding,
                      bottom: screenPadding,
                    ),
                    child: Column(
                      spacing: 15,
                      children: [
                        Text(
                          "QR code below will expire at ${(expiredTime().hour).toString().padLeft(2, '0')}:${(expiredTime().minute).toString().padLeft(2, '0')}",
                          style: content,
                        ),
                        Center(child: QRImage(uniqueCode)),
                        Text(
                          "Regenarate QR Code",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                            color: Color(secondaryColor2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenPadding),
              child: Column(
                spacing: 50,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your ${isConsult ? "Profile" : "Consultation"}",
                        style: header2,
                      ),
                      RecordCard(
                        title: "ABCDE",
                        subtitle: "Female | 21 years old",
                        info1: "123",
                        info2: "123",
                        isMed: false,
                      ),
                    ],
                  ),
                  WarningCard(
                    isConsult
                        ? "Make sure your physician already asks for your information!"
                        : "You can only purchase this prescription once!",
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

DateTime expiredTime() {
  DateTime current = DateTime.now();
  Duration duration = Duration(minutes: 5);
  DateTime expired = current.add(duration);

  return expired;
}
