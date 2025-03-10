import 'package:flutter/material.dart';
import 'package:medigram_app/constants/style.dart';

class Button extends StatelessWidget {
  const Button(
    this.text,
    this.handler,
    this.isSubmit,
    this.isPrimary, {
    super.key,
  });

  final String text;
  final VoidCallback handler;
  final bool isSubmit;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSubmit ? Color(secondaryColor2) : Color(primaryColor2),
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(isPrimary ? 15 : 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: isPrimary ? header2 : body),
      ),
    );
  }
}
