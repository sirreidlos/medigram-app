import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/utils/style.dart';

class Input extends StatelessWidget {
  const Input({
    required this.header,
    required this.placeholder,
    required this.isDisabled,
    this.initValue,
    this.iconVerified,
    super.key,
  });

  final String header;
  final String placeholder;
  final bool isDisabled;
  final String? initValue;
  final bool? iconVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Color(secondaryColor1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 0,
              children: [
                Container(
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(header, style: body),
                ),
                TextFormField(
                  initialValue: initValue,
                  maxLines: 1,
                  readOnly: isDisabled ? true : false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    border: InputBorder.none,
                    hintText: placeholder,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: (isDisabled ? Color(secondaryColor2) : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 0),
            child: checkIcon(iconVerified),
          ),
        ],
      ),
    );
  }
}

Widget checkIcon(bool? useIcon) {
  if (useIcon == null) return Icon(null);

  if (useIcon == true) return Icon(Icons.verified);

  return Icon(Icons.add_circle_outline);
}
