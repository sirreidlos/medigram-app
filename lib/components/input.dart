import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/constants/style.dart';

class Input extends StatelessWidget {
  const Input({
    required this.header,
    required this.placeholder,
    required this.isDisabled,
    required this.useIcon,
    required this.inputType,
    this.initValue,
    super.key,
  });

  final String header;
  final String placeholder;
  final bool isDisabled;
  final String? initValue;
  final Icon useIcon;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(secondaryColor1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0,
              children: [
                SizedBox(height: 30, child: Text(header, style: placeholder != "" ? body : header2)),
                placeholder != ""
                    ? TextFormField(
                      initialValue: initValue,
                      keyboardType: inputType,
                      maxLines: 1,
                      readOnly: isDisabled ? true : false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: placeholder,
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            (isDisabled
                                ? Color(secondaryColor2)
                                : Colors.black),
                      ),
                    )
                    : Container(),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: useIcon,
            iconSize: 20,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
