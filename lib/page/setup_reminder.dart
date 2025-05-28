import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/diagnosis.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/page/reminder.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/notification_service.dart';
import 'package:medigram_app/services/secure_storage.dart';

class SetupReminder extends StatefulWidget {
  const SetupReminder(this.consultation, {super.key});
  final Consultation consultation;

  @override
  State<SetupReminder> createState() => _SetupReminderState();
}

class _SetupReminderState extends State<SetupReminder> {
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();

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
              PopupHeader(MaterialPageRoute(
                builder: ((context) {
                  return ReminderPage();
                }),
              ), "Setup Reminder", true),
              Text(
                "Consultation Info",
                style: header2,
              ),
              FutureBuilder(future: () async {
                return getDoctor(widget.consultation.doctorID);
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
                          title: "Dr. ${doctor.name}",
                          subtitle: "PRACTICE ADDRESS", // TODO Get correct address
                          info1: getDate(widget.consultation.createdAt
                              .add(Duration(hours: 7))),
                          info2: DateFormat('HH:mm').format(widget
                              .consultation.createdAt
                              .add(Duration(hours: 7))),
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
                return getDiagnoses(widget.consultation.consultationID);
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
                return getPrescription(widget.consultation.consultationID);
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
              widget.consultation.reminded == true
                  ? Container()
                  : Column(
                      spacing: screenPadding,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                            "Setup Reminder",
                            style: header2,
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () => displayDatePicker(context),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(spacing: 10, children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Color(secondaryColor2),
                                  ),
                                  Text(
                                    'Select Date',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(secondaryColor1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  "Start Date: ${DateFormat("dd MMMM yyyy").format(startDate)}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () => displayTimePicker(context),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(spacing: 10, children: [
                                  Icon(Icons.timelapse_rounded,
                                      color: Color(secondaryColor2)),
                                  Text(
                                    'Select Time',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(secondaryColor1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  "Start Time: ${startTime.hour}:${startTime.minute}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                  child: Button(
                                      "Cancel",
                                      () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) {
                                                return ReminderPage();
                                              }),
                                            ),
                                          ),
                                      false,
                                      true,
                                      false)),
                              Expanded(
                                  child: ElevatedButton(
                                onPressed: () => submitReminder(
                                    widget.consultation.consultationID),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(secondaryColor2),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(color: Color((0xffffff))),
                                ),
                                child: Text("Save Reminder", style: header2),
                              ))
                            ],
                          ),
                        ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitReminder(String consultationID) async {
    DateTime start = new DateTime(startDate.year, startDate.month,
        startDate.day, startTime.hour, startTime.minute);
    final listPrescription = await getPrescription(consultationID);
    NotificationService().scheduleAllNotification(start, listPrescription);

    final response = ConsultationService().putReminder(consultationID);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Setup Finished!'),
            content: Text(
                'Don\'t forget to take your medicine regularly. Keep Healthy!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Back to Home'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return ReminderPage();
                      }),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<void> displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(secondaryColor2), // Warna header & tombol OK
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Colors.black, // Warna teks di tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Color(secondaryColor1), // Warna tombol CANCEL & OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  Future<void> displayTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<Doctor> getDoctor(String doctorID) async {
    final response = await DoctorService().getDoctorByID(doctorID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data);
    return doctor;
  }

  Future<List<Prescription>> getPrescription(String consultationID) async {
    final response =
        await ConsultationService().getPrescription(consultationID);
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
}
