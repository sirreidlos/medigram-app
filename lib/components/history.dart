import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';

class RecordHistory extends StatelessWidget {
  const RecordHistory(this.isPatient, this.topN, {super.key});

  final bool isPatient;
  final bool topN;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showRecords(isPatient),
    );
  }

  Widget showRecords(bool isPatient) {
    return FutureBuilder(
        future: getConsultation(isPatient),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final listConsult = snapshot.data;
            if (listConsult!.isEmpty) {
              return SizedBox(
                  width: double.infinity,
                  child: Text(
                    "No consultations yet!",
                    style: body,
                  ));
            }
            return ListView.builder(
                itemCount: topN
                    ? (listConsult.length < 3 ? listConsult.length : 3)
                    : listConsult.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RecordCard(
                    title: isPatient
                        ? (getUserDetail(listConsult![index].doctorID)
                                as UserDetail)
                            .name
                        : (getUserDetail(listConsult![index].userID)
                                as UserDetail)
                            .name,
                    subtitle:
                        (getDoctor(listConsult![index].doctorID) as Doctor)
                            .practiceAddress,
                    // info1: listConsult![index].CreatedAt, // TODO Update API
                    // info2: listConsult![index].CreatedAt,
                    info1: "0/0/0",
                    info2: "12:12",
                    isMed: false,
                  );
                });
          } else {
            return SizedBox(
                width: double.infinity,
                child: Text(
                  "No consultations yet!",
                  style: body,
                ));
          }
        });
  }

  Future<List<Consultation>> getConsultation(bool isPatient) async {
    // if (isPatient == true) {
    final response = await ConsultationService().getOwnConsultation();
    final List data = jsonDecode(response.body);
    return data.map((e) => Consultation.fromJson(e)).toList();
    // } else {
    // final response = await ConsultationService().getConsultationDoctor(); // TODO Add route
    // final List data = jsonDecode(response.body);
    // return data.map((e) => Consultation.fromJson(e)).toList();
    // }
  }

  Future<UserDetail> getUserDetail(String userID) async {
    // final response = await UserService().getUserDetail(userID); //TODO Add route
    final response = await UserService().getOwnDetail();
    Map<String, dynamic> data = jsonDecode(response.body);
    UserDetail user = UserDetail.fromJson(data);
    return user;
  }

  Future<Doctor> getDoctor(String doctorID) async {
    final response = await DoctorService().getDoctorByID(doctorID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data);
    return doctor;
  }
}
