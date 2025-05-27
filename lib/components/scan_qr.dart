import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:medigram_app/page/form.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/page/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQR extends StatelessWidget {
  const ScanQR({super.key});

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
                  PopupHeader(MaterialPageRoute(
                    builder: ((context) {
                      return HomePage();
                    }),
                  ), "Scan Patient Data"),
                  Container(
                    padding: EdgeInsets.only(
                      top: screenPadding,
                      bottom: screenPadding,
                    ),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: MobileScanner(
                        scanWindow: Rect.fromLTWH(
                          screenPadding,
                          screenPadding,
                          300,
                          300,
                        ),
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final String? raw = barcodes.first.rawValue;
                            if (raw != null) {
                              try {
                                final String jsonString =
                                    utf8.decode(base64Decode(raw));
                                final Map<String, dynamic> data =
                                    jsonDecode(jsonString);
                                final qrData = QrData.fromJson(data);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConsultForm(qrData),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'QR code has expired. Must regenerate the QR.')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
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
