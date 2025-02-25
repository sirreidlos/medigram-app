import 'package:flutter/material.dart';
import 'package:medigram_app/utils/style.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(secondaryColor1),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        spacing: 15,
        children: [
          Expanded(
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Doctor Name",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  "Practice Location Practice Location Practice Location Practice Location",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "00:00",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(secondaryColor2)
                ),
              ),
              Text(
                "00/00/00",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(secondaryColor2)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}