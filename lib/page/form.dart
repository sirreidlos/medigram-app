import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/utils/dob_age.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/constants/style.dart';

class ConsultForm extends StatefulWidget {
  const ConsultForm(this.barcode, {super.key});
  final String barcode;

  @override
  State<ConsultForm> createState() => _ConsultFormState();
}

class _ConsultFormState extends State<ConsultForm> {
  final TextEditingController diagnosesController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController drugController = TextEditingController();
  final TextEditingController dosesController = TextEditingController();
  final TextEditingController regimenController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();

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
            child: FutureBuilder(
                future: Future.wait(
                    [getUserDetail(), getUserMeasurement(), getUserAllergy()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    UserDetail user = snapshot.data![0] as UserDetail;
                    UserMeasurement userDetail =
                        snapshot.data![1] as UserMeasurement;
                    List<Allergy> allergy = snapshot.data![2] as List<Allergy>;
                    return Column(
                      spacing: 15,
                      children: [
                        PopupHeader(context, "Prescription Form"),
                        SizedBox(
                          width: double.infinity,
                          child: Text("Patient Profile", style: header2),
                        ),
                        Input(
                          header: "Name",
                          placeholder: user.name,
                          isDisabled: true,
                          useIcon: Icon(null),
                          controller: TextEditingController(),
                          inputType: TextInputType.multiline,
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Input(
                                header: "Age",
                                placeholder:
                                    "${dobToAge(user.dob)[2]} years ${dobToAge(user.dob)[1]} months",
                                isDisabled: true,
                                useIcon: Icon(null),
                          controller: TextEditingController(),
                                inputType: TextInputType.multiline,
                              ),
                            ),
                            Expanded(
                              child: Input(
                                header: "Gender",
                                placeholder:
                                    user.gender == "M" ? "Male" : "Female",
                                isDisabled: true,
                                useIcon: Icon(null),
                          controller: TextEditingController(),
                                inputType: TextInputType.multiline,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Input(
                                header: "Height (cm)",
                                placeholder: userDetail.heightInCm.toString(),
                                isDisabled: true,
                                useIcon: Icon(null),
                          controller: TextEditingController(),
                                inputType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: Input(
                                header: "Weight (kg)",
                                placeholder: userDetail.weightInKg.toString(),
                                isDisabled: true,
                                useIcon: Icon(null),
                          controller: TextEditingController(),
                                inputType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Input(
                              header: "Allergy*",
                              placeholder: allergy.isEmpty
                                  ? "-"
                                  : allergy
                                      .map((a) =>
                                          "${a.allergen} (${getSeverity(a.severity)})")
                                      .join(", "),
                              isDisabled: true,
                              useIcon: Icon(null),
                          controller: TextEditingController(),
                              inputType: TextInputType.multiline,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "*M = Mild, MOD = Moderate, S = Severe, C = Critical",
                                style: content,
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Input(
                          header: "Medical Conditions", //TODO Add field
                          placeholder: "ADHD AUTISM",
                          isDisabled: true,
                          useIcon: Icon(null),
                          controller: TextEditingController(),
                          inputType: TextInputType.multiline,
                        ),
                        LineDivider(),
                        SizedBox(
                          width: double.infinity,
                          child: Text("Consultation", style: header2),
                        ),
                        Input(
                          header: "Diagnoses",
                          placeholder: "Your patient diagnoses",
                          isDisabled: false,
                          useIcon: Icon(null),
                          controller: diagnosesController,
                          inputType: TextInputType.multiline,
                        ),
                        Input(
                          header: "Symptoms",
                          placeholder: "Your patient symptoms",
                          isDisabled: false,
                          useIcon: Icon(null),
                          controller: symptomsController,
                          inputType: TextInputType.multiline,
                        ),
                        LineDivider(),
                        SizedBox(
                          width: double.infinity,
                          child: Text("Medicine", style: header2),
                        ),
                        Input(
                          header: "Drug Name",
                          placeholder: "Medicine for your patient",
                          isDisabled: false,
                          useIcon: Icon(null),
                          controller: drugController,
                          inputType: TextInputType.multiline,
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Input(
                                header: "Doses (mg)",
                                placeholder: "Doses in mg",
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: dosesController,
                                inputType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: Input(
                                header: "Daily Regimen",
                                placeholder: "Per day",
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: regimenController,
                                inputType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        Input(
                          header: "Quantity (/dose)",
                          placeholder: "Per dose",
                          isDisabled: false,
                          useIcon: Icon(null),
                          controller: quantityController,
                          inputType: TextInputType.number,
                        ),
                        Input(
                          header: "Instruction",
                          placeholder: "How to consume",
                          isDisabled: false,
                          useIcon: Icon(null),
                          controller: instructionController,
                          inputType: TextInputType.multiline,
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                                child:
                                    Button("Reset", () {}, false, false, true)),
                            Expanded(
                                child: Button("Add", () {}, true, false, true)),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: RecordCard(
                                title: "Penicillin 165 mg",
                                subtitle: "3 times/day, after meal",
                                info1: "21x",
                                info2: "",
                                isMed: true,
                              ),
                            ),
                          ],
                        ),
                        WarningCard(
                          "Make sure your diagnoses and prescription are suitable for the patient!",
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                                child: Button(
                                    "Cancel", () {}, false, true, false)),
                            Expanded(
                                child: Button(
                                    "Prescribe", () {}, true, true, false)),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No data found"));
                  }
                })),
      ),
    );
  }
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

  dataList.sort((a, b) => DateTime.parse(a['measured_at'])
      .compareTo(DateTime.parse(b['measured_at'])));

  Map<String, dynamic> lastData = dataList.last;
  UserMeasurement userDetail = UserMeasurement.fromJson(lastData);
  return userDetail;
}

Future<List<Allergy>> getUserAllergy() async {
  final response = await UserService().getOwnAllergy();
  List<dynamic> data = jsonDecode(response.body);
  List<Allergy> allergies = data.map((e) => Allergy.fromJson(e)).toList();
  return allergies;
}

String getSeverity(String severity) {
  if (severity == "MILD") {
    return "M";
  } else if (severity == "MODERATE") {
    return "MOD";
  } else if (severity == "SEVERE") {
    return "S";
  }

  return "C";
}
