import 'package:flutter/material.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/utils/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Color(secondaryColor1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40), 
                  bottomRight: Radius.circular(40))
              ),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hello, Jane Doe",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Icon(
                        Icons.swap_horiz_rounded
                      ),
                      Icon(
                        Icons.notifications
                      )
                    ]
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(primaryColor1),
                        padding: EdgeInsets.zero,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Start Consultation",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                      ),
                    ),
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(primaryColor2),
                            padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Meds Claim",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(secondaryColor2),
                            padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Meds Regimen",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Consultations",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  RecordCard(),
                  RecordCard()
                ],
              ),
            )
          ],
        ),
      );
  }}