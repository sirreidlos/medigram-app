import 'package:flutter/material.dart';
import 'package:medigram_app/constants/style.dart';

class RecordCard extends StatelessWidget {
  String title;
  String subtitle;
  String info1;
  String info2;
  bool isMed;
  VoidCallback? onPressed;

  RecordCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.info1,
    required this.info2,
    required this.isMed,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(secondaryColor1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            overflow: TextOverflow.ellipsis, style: body),
                        subtitle == ""
                            ? Container()
                            : Text(subtitle,
                                overflow: TextOverflow.ellipsis,
                                style: content),
                      ],
                    ),
                  ),
                  isMed
                      ? Text(info1, style: header2)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(info1, style: content),
                            Text(info2, style: content),
                          ],
                        ),
                ],
              ),
            )));
  }
}
