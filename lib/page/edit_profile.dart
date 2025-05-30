import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/doctor/location.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/models/user/user.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_full.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<UserFull> userData;
  bool isPatient = true;

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  final TextEditingController permitController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String severitySelected = "Mild (M)";

  List<Allergy> listAllergy = [];
  List<MedicalConditions> listConditions = [];
  List<String> deletedAllergy = [];
  List<String> deletedCondition = [];

  List<String> severityList = [
    "Mild (M)",
    "Moderate (MOD)",
    "Severe (S)",
    "Critical (C)"
  ];

  @override
  void initState() {
    super.initState();
    userData = fetchFullPatientData();
    getPatientStatus();
  }

  void addAllergy() {
    setState(() {
      listAllergy.add(Allergy(
          allergyID: "",
          userID: "",
          allergen: allergyController.text,
          severity: severitySelected));
    });
    resetAllergy();
  }

  void resetAllergy() {
    setState(() {
      allergyController.text = "";
      severitySelected = "Mild (M)";
    });
  }

  void removeAllergy(
    int index,
  ) {
    setState(() {
      deletedAllergy.add(listAllergy[index].allergyID);
      listAllergy.removeAt(index);
    });
  }

  void addCondition() {
    setState(() {
      listConditions.add(MedicalConditions(
          conditionsID: "", userID: "", conditions: conditionController.text));
      resetCondition();
    });
  }

  void resetCondition() {
    setState(() {
      conditionController.text = "";
    });
  }

  void removeCondition(int index) {
    setState(() {
      deletedCondition.add(listConditions[index].conditionsID);
      listConditions.removeAt(index);
    });
  }

  void severityController(String newValue) {
    setState(() {
      severitySelected = newValue;
    });
  }

  Future<void> getPatientStatus() async {
    bool response = await SharedPrefsHelper.getUserRole();
    setState(() {
      isPatient = response;
    });
  }

  Future<UserFull> fetchFullPatientData() async {
    final userMeasure = await getUserMeasurement();
    final listAllergy = await getUserAllergy();
    final listCondition = await getUserConditions();
    weightController.text = userMeasure.weightInKg.toString();
    heightController.text = userMeasure.heightInCm.toString();

    return UserFull(
      userMeasurement: userMeasure,
      listAllergy: listAllergy,
      listConditions: listCondition,
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
            child: Column(spacing: 15, children: [
              PopupHeader(MaterialPageRoute(
                builder: ((context) {
                  return BottomNavigationMenu(
                    isPatient,
                    initialIndex: 2,
                  );
                }),
              ),
                  isPatient
                      ? "Edit Health Information"
                      : "Edit Practice Information",
                  true),
              SizedBox(
                width: double.infinity,
                child: Text(
                    isPatient ? "Health Infomation" : "Practice Information",
                    style: header2),
              ),
              isPatient
                  ? (FutureBuilder<UserFull>(
                      future: userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          UserMeasurement userDetail =
                              snapshot.data!.userMeasurement;
                          listAllergy = snapshot.data!.listAllergy;
                          listConditions = snapshot.data!.listConditions;
                          return Column(
                            spacing: 15,
                            children: [
                              Input(
                                header: "Height (cm)",
                                placeholder: userDetail.heightInCm.toString(),
                                isDisabled: false,
                                controller: heightController,
                                inputType: TextInputType.number,
                              ),
                              Input(
                                header: "Weight (kg)",
                                placeholder: userDetail.weightInKg.toString(),
                                isDisabled: false,
                                controller: weightController,
                                inputType: TextInputType.number,
                              ),
                              Column(
                                spacing: screenPadding,
                                children: [showAllergy(), allergyField()],
                              ),
                              Column(
                                spacing: screenPadding,
                                children: [showCondition(), conditionField()],
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text("No data found"));
                        }
                      }))
                  : Column(spacing: 15, children: [
                      FutureBuilder(
                          future: getDoctor(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              Doctor doctor = snapshot.data!;
                              List<PracticeLocation> listLocation =
                                  doctor.locations!;
                              return Column(
                                  spacing: 10,
                                  children: List.generate(listLocation.length,
                                      (index) {
                                    return Row(
                                      spacing: 5,
                                      children: [
                                        SizedBox(
                                            child: listLocation[index]
                                                        .approvedAt ==
                                                    null
                                                ? Icon(Icons
                                                    .pending_actions_rounded)
                                                : Icon(
                                                    Icons
                                                        .verified_user_outlined,
                                                    color: Color(primaryColor1),
                                                  )),
                                        Expanded(
                                            child: RecordCard(
                                          title: listLocation[index]
                                              .practicePermit,
                                          subtitle: listLocation[index]
                                              .practiceAddress,
                                          info1: "",
                                          info2: "",
                                          isMed: false,
                                        )),
                                        SizedBox(
                                            child: IconButton(
                                                onPressed: () =>
                                                    removePractice(index),
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                icon: Icon(Icons
                                                    .remove_circle_outline_rounded))),
                                      ],
                                    );
                                  }));
                            } else {
                              return Center(child: Text("No data found"));
                            }
                          }),
                      SizedBox(
                        width: double.infinity,
                        child: Text("Add new practice", style: header2),
                      ),
                      Column(
                        spacing: 10,
                        children: [
                          Input(
                            header: "Permit",
                            placeholder: "The practice permit",
                            isDisabled: false,
                            controller: permitController,
                            inputType: TextInputType.multiline,
                          ),
                          Input(
                            header: "Address",
                            placeholder: "The practice full address",
                            isDisabled: false,
                            controller: addressController,
                            inputType: TextInputType.multiline,
                          ),
                        ],
                      ),
                    ]),
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
                                        return BottomNavigationMenu(
                                          isPatient,
                                          initialIndex: 2,
                                        );
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
                      child: Button(
                          isPatient ? "Save Changes" : "Add Practice",
                          () => isPatient ? saveProfile() : savePractice(),
                          true,
                          true,
                          false)),
                ],
              ),
            ])),
      ),
    );
  }

  Future<void> removePractice(int index) async {
    AlertDialog(
      title: const Text('Confirmation'),
      content: Text(
          'Are you sure want to delete this practice? This action can not be reversed.'),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            // final response = await DoctorService() //TODO Delete Doctor
          },
        ),
      ],
    );
  }

  Future savePractice() async {
    String permit = permitController.text;
    String address = addressController.text;

    final response = await DoctorService().postOwnPractice(permit, address);
    final int code = response.statusCode;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                code == 201 ? 'Changes saved successfully!' : "Network Error!"),
            content: Text(code == 201
                ? 'Stay Healthy!'
                : 'We\'re sorry, there is some problem with the system. Try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Back to Home'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return BottomNavigationMenu(
                          isPatient,
                          initialIndex: 2,
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Future saveProfile() async {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    final responseMeasurement =
        await UserService().postOwnMeasurements(weight, height);

    for (var allergyID in deletedAllergy) {
      if (allergyID == "") continue;
      final responseDelAllergy = await UserService().deleteAllergy(allergyID);
    }
    for (var conditionID in deletedCondition) {
      if (conditionID == "") continue;
      final responseDelCondition =
          await UserService().deleteConditions(conditionID);
    }

    for (var allergy in listAllergy) {
      if (allergy.allergyID != "") continue;
      final responseAllergy = await UserService()
          .postOwnAllergy(allergy.allergen, allergy.severity);
    }
    for (var condition in listConditions) {
      if (condition.conditionsID != "") continue;
      final responseCondition =
          await UserService().postOwnConditions(condition.conditions);
    }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Changes saved successfully!'),
            content: Text('Stay Healthy!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Back to Home'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return BottomNavigationMenu(
                          isPatient,
                          initialIndex: 2,
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Widget conditionField() {
    return Column(
      spacing: 20,
      children: [
        Input(
          header: "Medical Conditions",
          placeholder: "Add new condition",
          isDisabled: false,
          controller: conditionController,
          inputType: TextInputType.multiline,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: Button("Reset Condition", () => resetCondition(), false,
                    false, true)),
            Expanded(
                child: Button(
                    "Add Condition", () => addCondition(), true, false, true)),
          ],
        ),
      ],
    );
  }

  Widget showCondition() {
    return Column(spacing: 10, children: [
      SizedBox(
        width: double.infinity,
        child: Text("Medical Conditions", style: header2),
      ),
      Column(
          spacing: 5,
          children: List.generate(listConditions.length, (index) {
            return Row(
              children: [
                Expanded(
                    child: RecordCard(
                  title: listConditions[index].conditions,
                  subtitle: "",
                  info1: "",
                  info2: "",
                  isMed: true,
                )),
                IconButton(
                    onPressed: () => removeCondition(index),
                    icon: Icon(Icons.remove_circle_outline_rounded))
              ],
            );
          }))
    ]);
  }

  Widget allergyField() {
    return Column(
      spacing: 20,
      children: [
        Row(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Input(
              header: "Allergy",
              placeholder: "Add new allergy",
              isDisabled: false,
              controller: allergyController,
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
                  onChanged: (String? newValue) =>
                      severityController(newValue!)),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: Button(
                    "Reset Allergy", () => resetAllergy(), false, false, true)),
            Expanded(
                child: Button(
                    "Add Allergy", () => addAllergy(), true, false, true)),
          ],
        ),
      ],
    );
  }

  Widget showAllergy() {
    return Column(spacing: 10, children: [
      SizedBox(
        width: double.infinity,
        child: Text("Allergies", style: header2),
      ),
      Column(
          spacing: 5,
          children: List.generate(listAllergy.length, (index) {
            return Row(
              children: [
                Expanded(
                    child: RecordCard(
                  title: listAllergy[index].allergen,
                  subtitle: listAllergy[index].severity,
                  info1: "",
                  info2: "",
                  isMed: true,
                )),
                IconButton(
                    onPressed: () => removeAllergy(index),
                    icon: Icon(Icons.remove_circle_outline_rounded))
              ],
            );
          }))
    ]);
  }

  Future<Doctor> getDoctor() async {
    User user = await getUser();
    String userID = user.userID;

    final response = await DoctorService().getDoctorByUserID(userID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data);
    return doctor;
  }

  Future<User> getUser() async {
    final response = await UserService().getOwnInfo();
    Map<String, dynamic> data = jsonDecode(response.body);
    User user = User.fromJson(data);
    return user;
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
    dataList.sort((a, b) => DateTime.parse(b['measured_at'])
        .compareTo(DateTime.parse(a['measured_at'])));

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

  Future<List<MedicalConditions>> getUserConditions() async {
    final response = await UserService().getOwnConditions();
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
}
