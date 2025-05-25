import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/consultation.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/reminder_service.dart';
import 'package:medigram_app/services/secure_storage.dart';

class SetupReminder extends StatefulWidget {
  const SetupReminder(this.consultation, {super.key});
  final Consultation consultation;

  @override
  State<SetupReminder> createState() => _SetupReminderState();
}

class _SetupReminderState extends State<SetupReminder> {
  String startDate = "-";
  String startTime = "-";

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
              PopupHeader(context, "Setup Reminder"),
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
                  Doctor doctor = snapshot.data as Doctor;
                  return RecordCard(
                      title: doctor.name,
                      subtitle: doctor.practiceAddress,
                      info1: getDate(widget.consultation.createdAt),
                      info2: DateFormat('HH:mm')
                          .format(widget.consultation.createdAt),
                      isMed: false);
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
                  return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Prescription pres = listPres[index];
                        return RecordCard(
                          title: pres.drugName,
                          subtitle:
                              "${pres.regimenPerDay} times/day, ${pres.instruction}",
                          info1: "${pres.quantityPerDose}x",
                          info2: "",
                          isMed: true,
                        );
                      });
                } else {
                  return Center(child: Text("No data found"));
                }
              }),
              Text("Start Date: $startDate"),
              ElevatedButton(
                onPressed: () => displayDatePicker(context),
                child: Text('Select Date'),
              ),
              Text("Start Time: $startTime"),
              ElevatedButton(
                onPressed: () => displayTimePicker(context),
                child: Text('Select Time'),
              ),
              ElevatedButton(
                onPressed: () => submitReminder(),
                child: Text('Save Reminder'),
              ),


            ],
          ),
        ),
      ),
    );
  }

  void submitReminder(){
    // ReminderService().scheduleAllReminders(pres)
  }

  Future<void> displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        startDate = date.toLocal().toString().split(" ")[0];
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
        startTime = pickedTime.toString();
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
    final userID = await SecureStorageService().read('user_id');
    final response =
        await ConsultationService().getPrescription(userID!, consultationID);
    final List data = jsonDecode(response.body);
    final List<Prescription> listConsult =
        data.map((e) => Prescription.fromJson(e)).toList();
    return listConsult;
  }

  String getDate(DateTime date) {
    DateTime current = DateTime.now();
    if (current.year - date.year > 0) return DateFormat('MM/y').format(date);
    return DateFormat('d/MM').format(date);
  }
}
