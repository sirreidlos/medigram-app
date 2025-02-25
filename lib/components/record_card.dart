import 'package:flutter/material.dart';
import 'package:medigram_app/utils/style.dart';

class RecordCard extends StatelessWidget {
  String name;
  String location;
  String time;
  String date;

  RecordCard({super.key, 
    required this.name,
    required this.location,
    required this.time,
    required this.date
  });

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  location,
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
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(secondaryColor2)
                ),
              ),
              Text(
                date,
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