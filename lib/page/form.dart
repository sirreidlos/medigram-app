import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ConsultForm extends StatelessWidget {
  const ConsultForm(this.barcode, {super.key});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(60),
        child: Text(barcode),
      ),
    );
  }
}