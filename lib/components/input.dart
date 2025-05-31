import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/constants/style.dart';

class Input extends StatefulWidget {
  const Input({
    required this.header,
    required this.placeholder,
    required this.isDisabled,
    required this.inputType,
    required this.controller,
    super.key,
  });

  final String header;
  final String placeholder;
  final bool isDisabled;
  final TextInputType inputType;
  final TextEditingController controller;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: widget.isDisabled ? EdgeInsets.zero : EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isDisabled
            ? Colors.transparent
            : Color(secondaryColor1).withValues(alpha: 0.65),
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
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.header,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                widget.placeholder != ""
                    ? TextFormField(
                        keyboardType: widget.inputType,
                        maxLines: null,
                        readOnly: widget.isDisabled ? true : false,
                        controller: widget.controller,
                        onChanged: (value) {
                          setState(() {
                            widget.controller.text = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                            hintText: widget.placeholder,
                            hintStyle: TextStyle(
                                color: widget.isDisabled
                                    ? Color(secondaryColor2)
                                    : Colors.black.withValues(alpha: 0.5))),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: widget.isDisabled
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: (widget.isDisabled
                              ? Color(secondaryColor2)
                              : Colors.black),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
