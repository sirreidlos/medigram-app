import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/consultation_card.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/page/consultation_info.dart';
import 'package:medigram_app/page/setup_reminder.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';

class RecordHistory extends StatelessWidget {
  const RecordHistory(
      {required this.isPatient,
      required this.topN,
      this.isReminder,
      super.key});

  final bool isPatient;
  final bool topN;
  final bool? isReminder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showRecords(isPatient, context),
    );
  }

  Widget showRecords(bool isPatient, BuildContext context) {
    return FutureBuilder(
        future: getConsultation(isPatient, context),
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
            return Column(
                spacing: 10,
                children: List.generate(
                    topN
                        ? (listConsult.length < 3 ? listConsult.length : 3)
                        : listConsult.length, (index) {
                  ConsultationDetail consult = listConsult[index];
                  return RecordCard(
                    title: consult.title,
                    subtitle: consult.practiceAddress,
                    info1: getDate(consult.consultation.createdAt),
                    info2: DateFormat('HH:mm').format(
                        consult.consultation.createdAt.add(Duration(hours: 7))),
                    isMed: false,
                    onPressed: consult.onPressed,
                  );
                }));
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

  Future<List<ConsultationDetail>> getConsultation(
      bool isPatient, BuildContext context) async {
    List<Consultation> listConsult;
    if (isPatient == true) {
      final response = await ConsultationService().getOwnConsultation();
      final List data = jsonDecode(response.body);
      listConsult = data.map((e) => Consultation.fromJson(e)).toList();

      if (isReminder != null) {
        listConsult = data
            .where((e) => e['reminded'] == (isReminder! ? false : true))
            .map((e) => Consultation.fromJson(e))
            .toList();
      }
    } else {
      final response = await ConsultationService().getDoctorConsultation();
      final List data = jsonDecode(response.body);
      listConsult = data.map((e) => Consultation.fromJson(e)).toList();
    }
    listConsult.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    List<ConsultationDetail> listDetail = [];
    for (var consult in listConsult) {
      Doctor doctor = await getDoctor(consult.doctorID);
      UserDetail patient = await getUserByID(consult.userID);
      String title = isPatient ? "Dr. ${doctor.name}" : patient.name;
      listDetail.add(ConsultationDetail(
        consultation: consult,
        title: title,
        // practiceAddress: doctor.practiceAddress,
                          practiceAddress: "PRACTICE ADDRESS", // TODO Get correct address
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                if (isReminder != null) {
                  return SetupReminder(consult);
                }
                return ConsultationInfo(consult);
              }),
            ),
          );
        },
      ));
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
    date = date.add(Duration(hours: 7));
    DateTime current = DateTime.now();
    if (current.year - date.year > 0) return DateFormat('MM/y').format(date);
    return DateFormat('d/MM').format(date);
  }
}
