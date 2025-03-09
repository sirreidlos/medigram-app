import 'package:flutter/material.dart';
import 'package:medigram_app/constants/style.dart';

class PopupHeader extends StatelessWidget {
  const PopupHeader(this.prevPage, this.header, {super.key});

  final BuildContext prevPage;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(prevPage);
          },
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        Text(header, style: header2),
      ],
    );
  }
}
