import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/form.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/services/secure_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR(this.locationID, {super.key});
  final String locationID;

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  late final MobileScannerController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

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
                      return BottomNavigationMenu(false);
                    }),
                  ), "Scan Patient Data", false),
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
                        controller: cameraController,
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
                                final currentUserID =
                                    SecureStorageService().read('user_id');
                                if ((qrData.expiredAt
                                        .isBefore(DateTime.now())) ||
                                    (qrData.userID == currentUserID)) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('QR Invalid!'),
                                          content: Text(qrData.userID ==
                                                  currentUserID
                                              ? 'You can not diagnose yourself!'
                                              : 'Kindly inform your patient to regenerate the QR to continue with the consultation'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Back to Home'),
                                              onPressed: () {},
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConsultForm(qrData, widget.locationID),
                                    ),
                                  );
                                }
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
