import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/consultation_card.dart';
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
            return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: topN
                    ? (listConsult.length < 3 ? listConsult.length : 3)
                    : listConsult.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ConsultationDetail consult = listConsult[index];
                  return RecordCard(
                    title: consult.title,
                    subtitle: consult.practiceAddress,
                    info1: getDate(consult.consultation.createdAt),
                    info2: DateFormat('HH:mm')
                        .format(consult.consultation.createdAt),
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

  Future<List<ConsultationDetail>> getConsultation(bool isPatient) async {
    List<Consultation> listConsult;
    if (isPatient == true) {
      final response = await ConsultationService().getOwnConsultation();
      final List data = jsonDecode(response.body);
      listConsult = data.map((e) => Consultation.fromJson(e)).toList();
    } else {
      final response = await ConsultationService().getDoctorConsultation();
      final List data = jsonDecode(response.body);
      listConsult = data.map((e) => Consultation.fromJson(e)).toList();
    }

    List<ConsultationDetail> listDetail = [];
    for (var consult in listConsult) {
      Doctor doctor = await getDoctor(consult.doctorID);
      UserDetail patient = await getUserByID(consult.userID);
      String title = "DOCTOR OR PATIENT NAME";
      // String title = isPatient ? "Dr. ${doctor.name}" : patient.name; //TODO Update
      listDetail.add(ConsultationDetail(
          consultation: consult,
          title: title,
          practiceAddress: doctor.practiceAddress));
    }
    return listDetail;
  }

  Future<UserDetail> getUserByID(String userID) async {
    final response = await UserService().getUserDetail(userID);
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

  String getDate(DateTime date) {
    DateTime current = DateTime.now();
    if (current.year - date.year > 0) return DateFormat('MM/y').format(date);
    return DateFormat('d/MM').format(date);
  }
}
