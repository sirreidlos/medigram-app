import 'package:flutter/material.dart';

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
                color: Color(0xfff0f0f0),
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
                        backgroundColor: Color(0xff53daf5),
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
                            backgroundColor: Color(0xff2ca58d),
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
                            backgroundColor: Color(0xff003e6b),
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
          ],
        ),
      );
  }}