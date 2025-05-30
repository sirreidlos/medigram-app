import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/consultation_card.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/prescription_info.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';

class MedicineClaim extends StatelessWidget {
  const MedicineClaim({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            screenPadding,
            topScreenPadding,
            screenPadding,
            screenPadding,
          ),
          child: Column(
            spacing: screenPadding,
            children: [
              PopupHeader(MaterialPageRoute(builder: ((context) {
                return BottomNavigationMenu(true);
              })), "Medicine Claim", false),
              SizedBox(
                width: double.infinity,
                child: Text("Your consultations", style: header2),
              ),
              FutureBuilder(
                  future: getConsultation(context),
                  builder: (builder, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<ConsultationDetail> listConsult = snapshot.data!;
                      return Column(
                          spacing: 10,
                          children: List.generate(listConsult.length, (index) {
                            ConsultationDetail c = listConsult[index];
                            return RecordCard(
                                title: c.title,
                                subtitle: c.practiceAddress,
                                info1: getDate(c.consultation.createdAt),
                                info2: DateFormat('HH:mm').format(c
                                    .consultation.createdAt
                                    .add(Duration(hours: 7))),
                                isMed: false,
                                onPressed: c.onPressed);
                          }));
                    } else {
                      return Center(child: Text("No data"));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<ConsultationDetail>> getConsultation(BuildContext context) async {
  final response = await ConsultationService().getOwnConsultation();
  final List data = jsonDecode(response.body);
  List<Consultation> listConsult =
      data.map((e) => Consultation.fromJson(e)).toList();
  listConsult.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<ConsultationDetail> listDetail = [];
  for (var consult in listConsult) {
    Doctor doctor = await getDoctor(consult.doctorID);
    String title = "Dr. ${doctor.name}";
    String address = "";

    for (var loc in doctor.locations) {
      if (loc.locationID == consult.locationID) {
        address = loc.practiceAddress;
        break;
      }
    }

    listDetail.add(ConsultationDetail(
      consultation: consult,
      title: title,
      practiceAddress: address,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return PrescriptionInfo(consult.consultationID);
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
