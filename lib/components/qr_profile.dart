import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/services/user_service.dart';

class QRProfile extends StatelessWidget {
  const QRProfile(this.isConsult, {super.key});

  final bool isConsult;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenPadding),
      child: Column(
        spacing: 50,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your ${isConsult ? "Profile" : "Consultation"}",
                style: header2,
              ),
              showProfile(),
            ],
          ),
          WarningCard(
            isConsult
                ? "Make sure your physician already asks for your information!"
                : "You can only purchase this prescription once!",
          ),
        ],
      ),
    );
  }

  Widget showProfile() {
    return FutureBuilder(
        future: Future.wait([getUserDetail(), getUserMeasurement()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            UserDetail user = snapshot.data![0] as UserDetail;
            UserMeasurement userDetail = snapshot.data![1] as UserMeasurement;
            return RecordCard(
              title: user.name,
              subtitle: "${user.gender} | ${user.dob} years old",
              info1: "${userDetail.heightInCm} cm",
              info2: "${userDetail.weightInKg} kg",
              isMed: false,
            );
          } else {
            return Center(child: Text("No data found"));
          }
        });
  }

  Future<UserDetail> getUserDetail() async {
    final response = await UserService().getOwnDetail();
    Map<String, dynamic> data = jsonDecode(response.body);
    UserDetail user = UserDetail.fromJson(data);
    return user;
  }

  Future<UserMeasurement> getUserMeasurement() async {
    final response = await UserService().getOwnMeasurements();
    List<dynamic> dataList = jsonDecode(response.body);
    
    dataList.sort((a, b) =>
      DateTime.parse(a['measured_at']).compareTo(DateTime.parse(b['measured_at'])));

    Map<String, dynamic> lastData = dataList.last;
    UserMeasurement userDetail = UserMeasurement.fromJson(lastData);
    return userDetail;
  }
}
