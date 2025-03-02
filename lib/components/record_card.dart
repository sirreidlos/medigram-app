import 'package:flutter/material.dart';
import 'package:medigram_app/utils/style.dart';

class RecordCard extends StatelessWidget {
  String title;
  String subtitle;
  String info1;
  String info2;

  RecordCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.info1,
    required this.info2
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
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  subtitle,
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
                info1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(secondaryColor2)
                ),
              ),
              Text(
                info2,
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