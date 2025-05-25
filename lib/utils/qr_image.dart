import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  const QRImage(this.uniqueCode, {super.key});

  final QrData uniqueCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: QrImageView(
        data: compressedData(uniqueCode),
        size: 260,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      ),
    );
  }
}

String compressedData(QrData data){
  final String jsonString = jsonEncode(data.toJson());
  final String base64String = base64Encode(utf8.encode(jsonString));
  return base64String;
}
