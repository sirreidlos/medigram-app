import 'package:flutter/material.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/page/form.dart';
import 'package:medigram_app/constants/style.dart';
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
                  PopupHeader(context, "Scan Patient Data"),
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
                          String barcode = "";
                          for (final b in barcodes) {
                            barcode = barcode + (b.rawValue ?? "");
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return ConsultForm(barcode);
                              }),
                            ),
                          );
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
