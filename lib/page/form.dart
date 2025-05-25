import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/models/consultation/post_consult.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/models/user/user.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/utils/dob_age.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/constants/style.dart';

class ConsultForm extends StatefulWidget {
  const ConsultForm(this.qrData, {super.key});
  final QrData qrData;

  @override
  State<ConsultForm> createState() => _ConsultFormState();
}

class _ConsultFormState extends State<ConsultForm> {
  List<String> severityList = [
    "Mild (M)",
    "Moderate (MOD)",
    "Severe (S)",
    "Critical (C)"
  ];
  String severitySelected = "Mild (M)";

  final TextEditingController diagnosesController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();

  final TextEditingController drugController = TextEditingController();
  final TextEditingController dosesController = TextEditingController();
  final TextEditingController regimenController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();

  List<CPrescription> listPrescription = [];
  List<CDiagnosis> listDiagnosis = [];

  void addPrescription() {
    setState(() {
      listPrescription.add(CPrescription(
          drugName: drugController.text,
          dosesInMg: double.parse(dosesController.text),
          regimenPerDay: double.parse(regimenController.text),
          quantityPerDose: double.parse(quantityController.text),
          instruction: instructionController.text));
      resetPrescription();
    });
  }

  void resetPrescription() {
    setState(() {
      drugController.clear();
      dosesController.clear();
      regimenController.clear();
      quantityController.clear();
      instructionController.clear();
    });
  }

  void removePrescription(int index) {
    setState(() {
      listPrescription.removeAt(index);
    });
  }

  void addDiagnosis() {
    setState(() {
      listDiagnosis.add(CDiagnosis(
          diagnosis: diagnosesController.text,
          icdCode: "000",
          severity: severitySelected));
      resetDiagnosis();
    });
  }

  void resetDiagnosis() {
    setState(() {
      diagnosesController.clear();
      severitySelected = "Mild (M)";
    });
  }

  void removeDiagnosis(int index) {
    setState(() {
      listDiagnosis.removeAt(index);
    });
  }

  void severityController(String newValue) {
    setState(() {
      severitySelected = newValue;
    });
  }

  Future<Widget> saveConsultation() async {
    String userID = widget.qrData.userID;

    PostConsult consultData = PostConsult(
        consent: widget.qrData.consent,
        userID: userID,
        diagnosis: listDiagnosis,
        symptoms: symptomsController.text,
        prescription: listPrescription);
        
    final response =
        await ConsultationService().postConsultation(userID, consultData);

    return AlertDialog(
      title: const Text('Consultation Finished!'),
      content: Text(
          'Make sure the consultation has been saved in your patient\'s account. Tell your patient to refresh the application by dragging down on the screen.'),
      actions: <Widget>[
        TextButton(
          child: const Text('Back to Home'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

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
                future: Future.wait([
                  getUserDetail(widget.qrData.userID),
                  getUserMeasurement(widget.qrData.userID),
                  getUserAllergy(widget.qrData.userID),
                  getUserConditions(widget.qrData.userID),
                ]),
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
                    List<MedicalConditions> conditions = snapshot.data![3] as List<MedicalConditions>;
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          header: "Medical Conditions",
                          placeholder: conditions.isEmpty
                                  ? "-"
                                  : conditions
                                      .map((c) =>
                                          "${c.conditions}")
                                      .join(", "),
                          isDisabled: true,
                          useIcon: Icon(null),
                          controller: TextEditingController(),
                          inputType: TextInputType.multiline,
                        ),
                        LineDivider(),
                        consultSection(),
                        showDiagnosis(),
                        LineDivider(),
                        prescriptSection(),
                        showPrescript(),
                        WarningCard(
                          "Make sure your diagnoses and prescription are suitable for the patient!",
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                                child: Button(
                                    "Cancel",
                                    () => Navigator.pop(context),
                                    false,
                                    true,
                                    false)),
                            Expanded(
                                child: Button(
                                    "Prescribe",
                                    () => saveConsultation(),
                                    true,
                                    true,
                                    false)),
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

  Widget consultSection() {
    return Column(spacing: 15, children: [
      SizedBox(
        width: double.infinity,
        child: Text("Consultation", style: header2),
      ),
      Input(
        header: "Symptoms",
        placeholder: "Your patient symptoms",
        isDisabled: false,
        useIcon: Icon(null),
        controller: symptomsController,
        inputType: TextInputType.multiline,
      ),
      Row(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Input(
            header: "Diagnoses",
            placeholder: "Your patient diagnoses",
            isDisabled: false,
            useIcon: Icon(null),
            controller: diagnosesController,
            inputType: TextInputType.multiline,
          )),
          DropdownButton(
              value: severitySelected,
              items: severityList.map((String severity) {
                return DropdownMenuItem(value: severity, child: Text(severity));
              }).toList(),
              onChanged: (String? newValue) => severityController(newValue!)),
        ],
      ),
      Row(
        spacing: 10,
        children: [
          Expanded(
              child:
                  Button("Reset", () => resetDiagnosis(), false, false, true)),
          Expanded(
              child: Button("Add", () => addDiagnosis(), true, false, true)),
        ],
      ),
    ]);
  }

  Widget showDiagnosis() {
    return Column(
      children: [
        ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: listDiagnosis.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                      child: RecordCard(
                    title: listDiagnosis[index].diagnosis,
                    subtitle: listDiagnosis[index].severity,
                    info1: "",
                    info2: "",
                    isMed: true,
                  )),
                  IconButton(
                      onPressed: () => removeDiagnosis(index),
                      icon: Icon(Icons.remove_circle_outline_rounded))
                ],
              );
            }),
      ],
    );
  }

  Widget prescriptSection() {
    return Column(
      spacing: 15,
      children: [
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Button(
                    "Reset", () => resetPrescription(), false, false, true)),
            Expanded(
                child:
                    Button("Add", () => addPrescription(), true, false, true)),
          ],
        ),
      ],
    );
  }

  Widget showPrescript() {
    return Column(
      children: [
        ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: listPrescription.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                      child: RecordCard(
                    title: listPrescription[index].drugName,
                    subtitle:
                        "${listPrescription[index].regimenPerDay} times/day, ${listPrescription[index].instruction}",
                    info1: "${listPrescription[index].quantityPerDose}x",
                    info2: "",
                    isMed: true,
                  )),
                  IconButton(
                      onPressed: () => removePrescription(index),
                      icon: Icon(Icons.remove_circle_outline_rounded))
                ],
              );
            }),
      ],
    );
  }
}

Future<User> getUser(String userID) async {
  final response = await UserService().getUserInfo(userID);
  Map<String, dynamic> data = jsonDecode(response.body);
  User user = User.fromJson(data);
  return user;
}

Future<UserDetail> getUserDetail(String userID) async {
  final response = await UserService().getUserDetail(userID);
  Map<String, dynamic> data = jsonDecode(response.body);
  UserDetail user = UserDetail.fromJson(data);
  return user;
}

Future<UserMeasurement> getUserMeasurement(String userID) async {
  final response = await UserService().getUserMeasurement(userID);
  List<dynamic> dataList = jsonDecode(response.body);

  dataList.sort((a, b) => DateTime.parse(a['measured_at'])
      .compareTo(DateTime.parse(b['measured_at'])));

  Map<String, dynamic> lastData = dataList.last;
  UserMeasurement userDetail = UserMeasurement.fromJson(lastData);
  return userDetail;
}

Future<List<Allergy>> getUserAllergy(String userID) async {
  final response = await UserService().getUserAllergy(userID);
  List<dynamic> data = jsonDecode(response.body);
  List<Allergy> allergies = data.map((e) => Allergy.fromJson(e)).toList();
  return allergies;
}

Future<List<MedicalConditions>> getUserConditions(String userID) async {
  final response = await UserService().getUserConditions(userID);
  List<dynamic> data = jsonDecode(response.body);
  List<MedicalConditions> conditions = data.map((e) => MedicalConditions.fromJson(e)).toList();
  return conditions;
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
