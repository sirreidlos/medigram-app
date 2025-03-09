import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/constants/style.dart';

class WarningCard extends StatelessWidget {
  const WarningCard(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
        child: Column(
          children: [
            Text(
              "Attention!",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(primaryColor2),
              ),
            ),
            Text(text, textAlign: TextAlign.center, style: body),
          ],
        ),
      ),
    );
  }
}
