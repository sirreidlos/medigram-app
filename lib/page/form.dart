import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/scan_qr.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/models/consultation/post_consult.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_full.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/services/consultation_service.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/utils/dob_age.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/constants/style.dart';

class ConsultForm extends StatefulWidget {
  const ConsultForm(this.qrData, this.locationID, {super.key});
  final QrData qrData;
  final String locationID;

  @override
  State<ConsultForm> createState() => _ConsultFormState();
}

class _ConsultFormState extends State<ConsultForm> {
  late Future<UserFull> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchFullPatientData();
  }

  Future<UserFull> fetchFullPatientData() async {
    final userDetail = await getUserDetail(widget.qrData.userID);
    final userMeasure = await getUserMeasurement(widget.qrData.userID);
    final listAllergy = await getUserAllergy(widget.qrData.userID);
    final listCondition = await getUserConditions(widget.qrData.userID);

    return UserFull(
        userDetail: userDetail,
        userMeasurement: userMeasure,
        listAllergy: listAllergy,
        listConditions: listCondition);
  }

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
          diagnosis: diagnosesController.text, severity: severitySelected));
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

  Future<void> saveConsultation() async {
    String userID = widget.qrData.userID;
    List<CDiagnosis> modifiedList = listDiagnosis
        .map((item) => CDiagnosis(
            diagnosis: item.diagnosis,
            severity: item.severity.split(" ")[0].toUpperCase()))
        .toList();

    PostConsult consultData = PostConsult(
        consent: widget.qrData.consent,
        userID: userID,
        locationID: widget.locationID,
        diagnosis: modifiedList,
        symptoms: symptomsController.text,
        prescription: listPrescription);

    final response =
        await ConsultationService().postConsultation(userID, consultData);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (response.statusCode == 201) {
            return AlertDialog(
              title: const Text('Consultation Finished!'),
              content: Text(
                  'Make sure the consultation has been saved in your patient\'s account. Tell your patient to refresh the application by dragging down on the screen.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Back to Home'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) {
                          return BottomNavigationMenu(false);
                        }),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text('Network Error!'),
              content: Text("Error ${response.statusCode}: ${response.body}"),
              actions: <Widget>[
                TextButton(
                  child: const Text('Back to Home'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) {
                          return ScanQR(widget.locationID);
                        }),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        });
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
            child: Column(spacing: 15, children: [
              FutureBuilder<UserFull>(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      UserDetail user = snapshot.data!.userDetail!;
                      UserMeasurement userDetail =
                          snapshot.data!.userMeasurement;
                      List<Allergy> allergy = snapshot.data!.listAllergy;
                      List<MedicalConditions> conditions =
                          snapshot.data!.listConditions;
                      return Column(
                        spacing: 15,
                        children: [
                          PopupHeader(MaterialPageRoute(
                            builder: ((context) {
                              return BottomNavigationMenu(false);
                            }),
                          ), "Consultation Form", true),
                          SizedBox(
                            width: double.infinity,
                            child: Text("Patient Profile", style: header2),
                          ),
                          Input(
                            header: "Name",
                            placeholder: user.name,
                            isDisabled: true,
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
                                  controller: TextEditingController(),
                                  inputType: TextInputType.number,
                                ),
                              ),
                              Expanded(
                                child: Input(
                                  header: "Weight (kg)",
                                  placeholder: userDetail.weightInKg.toString(),
                                  isDisabled: true,
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
                                    .map((c) => "${c.conditions}")
                                    .join(", "),
                            isDisabled: true,
                            controller: TextEditingController(),
                            inputType: TextInputType.multiline,
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text("No data found"));
                    }
                  }),
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
                      child: Button("Cancel", () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: Text(
                                'Are you sure to go back? Your changes will not be saved.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {},
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) {
                                        return BottomNavigationMenu(false);
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }, false, true, false)),
                  Expanded(
                      child: Button("Prescribe", () => saveConsultation(), true,
                          true, false)),
                ],
              ),
            ])),
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
            controller: diagnosesController,
            inputType: TextInputType.multiline,
          )),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(secondaryColor1).withValues(alpha: 0.65),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: DropdownButton(
                value: severitySelected,
                items: severityList.map((String severity) {
                  return DropdownMenuItem(
                      value: severity,
                      child: Text(
                        severity,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ));
                }).toList(),
                onChanged: (String? newValue) => severityController(newValue!)),
          ),
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
        children: List.generate(listDiagnosis.length, (index) {
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
    }));
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
                controller: dosesController,
                inputType: TextInputType.number,
              ),
            ),
            Expanded(
              child: Input(
                header: "Daily Regimen",
                placeholder: "Per day",
                isDisabled: false,
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
          controller: quantityController,
          inputType: TextInputType.number,
        ),
        Input(
          header: "Instruction",
          placeholder: "How to consume",
          isDisabled: false,
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
        children: List.generate(listPrescription.length, (index) {
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
    }));
  }
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
  dataList.sort((a, b) => DateTime.parse(b['measured_at'])
      .compareTo(DateTime.parse(a['measured_at'])));

  Map<String, dynamic> lastData = dataList.first;
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
  List<MedicalConditions> conditions =
      data.map((e) => MedicalConditions.fromJson(e)).toList();
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
