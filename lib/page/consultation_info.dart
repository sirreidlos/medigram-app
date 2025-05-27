import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/diagnosis.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';

class ConsultationInfo extends StatelessWidget {
  const ConsultationInfo(this.consultation, {super.key});
  final Consultation consultation;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: SharedPrefsHelper.getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return PopupHeader(MaterialPageRoute(
                        builder: ((context) {
                          return BottomNavigationMenu(snapshot.data!);
                        }),
                      ), "Consultation Record", false);
                    } else {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                  }),
              Text(
                "Consultation Info",
                style: header2,
              ),
              FutureBuilder(future: () async {
                return getDoctor(consultation.doctorID);
              }(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Doctor doctor = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      RecordCard(
                          title: doctor.name,
                          subtitle: doctor.practiceAddress,
                          info1: getDate(
                              consultation.createdAt.add(Duration(hours: 7))),
                          info2: DateFormat('HH:mm').format(
                              consultation.createdAt.add(Duration(hours: 7))),
                          isMed: false),
                    ],
                  );
                } else {
                  return Center(child: Text("No data found"));
                }
              }),
              Text(
                "Diagnoses",
                style: header2,
              ),
              FutureBuilder(future: () async {
                return getDiagnoses(consultation.consultationID);
              }(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Diagnosis> listDiag = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: List.generate(listDiag.length, (index) {
                      Diagnosis diag = listDiag[index];
                      return RecordCard(
                        title: diag.diagnosis,
                        subtitle: diag.severity,
                        info1: "",
                        info2: "",
                        isMed: true,
                      );
                    }),
                  );
                } else {
                  return Center(child: Text("No data found"));
                }
              }),
              Text(
                "Prescription",
                style: header2,
              ),
              FutureBuilder(future: () async {
                return getPrescription(consultation.consultationID);
              }(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Prescription> listPres =
                      snapshot.data as List<Prescription>;
                  return Column(
                      spacing: 10,
                      children: List.generate(listPres.length, (index) {
                        Prescription pres = listPres[index];
                        return RecordCard(
                          title: pres.drugName,
                          subtitle:
                              "${pres.regimenPerDay} times/day, ${pres.instruction}",
                          info1: "${pres.quantityPerDose}x",
                          info2: "",
                          isMed: true,
                        );
                      }));
                } else {
                  return Center(child: Text("No data found"));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Doctor> getDoctor(String doctorID) async {
  final response = await DoctorService().getDoctorByID(doctorID);
  Map<String, dynamic> data = jsonDecode(response.body);
  Doctor doctor = Doctor.fromJson(data);
  return doctor;
}

Future<List<Prescription>> getPrescription(String consultationID) async {
  final response = await ConsultationService().getPrescription(consultationID);
  final List data = jsonDecode(response.body);
  final List<Prescription> listConsult =
      data.map((e) => Prescription.fromJson(e)).toList();
  return listConsult;
}

Future<List<Diagnosis>> getDiagnoses(String consultationID) async {
  final response = await ConsultationService().getDiagnosis(consultationID);
  final List data = jsonDecode(response.body);

  final List<Diagnosis> listConsult =
      data.map((e) => Diagnosis.fromJson(e)).toList();
  return listConsult;
}

String getDate(DateTime date) {
  DateTime current = DateTime.now();
  if (current.year - date.year > 0) return DateFormat('MM/y').format(date);
  return DateFormat('d/MM').format(date);
}
