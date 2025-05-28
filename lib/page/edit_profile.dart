import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  DateTime startDate = DateTime.now();
  String severitySelected = "Mild (M)";
  String genderSelected = "";

  List<Allergy> listAllergy = [];
  List<MedicalConditions> listConditions = [];

  List<String> genderList = [
    "Female (F)",
    "Male (M)",
  ];
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

  void removeAllergy(int index) {
    setState(() {
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
      listConditions.removeAt(index);
    });
  }

  void severityController(String newValue) {
    setState(() {
      severitySelected = newValue;
    });
  }

  void genderController(String newValue) {
    setState(() {
      genderSelected = newValue;
    });
  }

  Future<void> getPatientStatus() async {
    bool response = await SharedPrefsHelper.getUserRole();
    setState(() {
      isPatient = response;
    });
  }

  Future<UserFull> fetchFullPatientData() async {
    final user = await getUser();
    final userDetail = await getUserDetail();
    final userMeasure = await getUserMeasurement();
    final listAllergy = await getUserAllergy();
    final listCondition = await getUserConditions();

    return UserFull(
      user: user,
      userDetail: userDetail,
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
                          User userInfo = snapshot.data!.user!;
                          UserDetail user = snapshot.data!.userDetail;
                          UserMeasurement userDetail =
                              snapshot.data!.userMeasurement;
                          listAllergy = snapshot.data!.listAllergy;
                          listConditions = snapshot.data!.listConditions;
                          dobController.text =
                              DateFormat("dd MMMM yyyy").format(startDate);
                          if (genderSelected == "") {
                            genderSelected =
                                user.gender == "M" ? "Male (M)" : "Female (F)";
                          }
                          return Column(
                            spacing: 15,
                            children: [
                              PopupHeader(MaterialPageRoute(
                                builder: ((context) {
                                  return BottomNavigationMenu(
                                    isPatient,
                                    initialIndex: 2,
                                  );
                                }),
                              ), "Edit Profile", true),
                              SizedBox(
                                width: double.infinity,
                                child:
                                    Text("Personal Infomation", style: header2),
                              ),
                              Input(
                                header: "Name",
                                placeholder: user.name,
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: nameController,
                                inputType: TextInputType.multiline,
                              ),
                              Input(
                                header: "NIK",
                                placeholder: user.nik.toString(),
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: nikController,
                                inputType: TextInputType.multiline,
                              ),
                              Input(
                                header: "Email",
                                placeholder: userInfo.email,
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: emailController,
                                inputType: TextInputType.multiline,
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Input(
                                      header: "Age",
                                      placeholder: dobController.text,
                                      isDisabled: false,
                                      useIcon: Icon(null),
                                      controller: TextEditingController(),
                                      inputType: TextInputType.multiline,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => displayDatePicker(context),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(spacing: 10, children: [
                                      Icon(Icons.calendar_month,
                                          color: Color(secondaryColor2)),
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
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(secondaryColor1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Gender",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          child: DropdownButton(
                                              isExpanded: true,
                                              value: genderSelected,
                                              items: genderList
                                                  .map((String gender) {
                                                return DropdownMenuItem(
                                                    value: gender,
                                                    child: Text(
                                                      gender,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.5),
                                                      ),
                                                    ));
                                              }).toList(),
                                              onChanged: (String? newValue) =>
                                                  genderController(newValue!)),
                                        )
                                      ])),
                              Input(
                                header: "Height (cm)",
                                placeholder: userDetail.heightInCm.toString(),
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: heightController,
                                inputType: TextInputType.number,
                              ),
                              Input(
                                header: "Weight (kg)",
                                placeholder: userDetail.weightInKg.toString(),
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: weightController,
                                inputType: TextInputType.number,
                              ),
                              Column(
                                spacing: 20,
                                children: [showAllergy(), allergyField()],
                              ),
                              Column(
                                spacing: 20,
                                children: [showCondition(), conditionField()],
                              ),
                              // Input(
                              //   header: "Medical Conditions",
                              //   placeholder: conditions.isEmpty
                              //       ? "-"
                              //       : conditions
                              //           .map((c) => c.conditions)
                              //           .join(", "),
                              //   isDisabled: false,
                              //   useIcon: Icon(null),
                              //   controller: TextEditingController(),
                              //   inputType: TextInputType.multiline,
                              // ),
                            ],
                          );
                        } else {
                          return Center(child: Text("No data found"));
                        }
                      }))
                  : FutureBuilder(
                      future: getDoctor(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          Doctor doctor = snapshot.data!; // TODO Change to list
                          return Row(
                            children: [
                              Input(
                                header: "doctor.praticePermit",
                                placeholder: "doctor.practiceAddress",
                                isDisabled: false,
                                useIcon: Icon(null),
                                // useIcon: Icon(doctor.approved
                                //     ? Icons.verified_user_outlined
                                //     : Icons.pending_actions_rounded),
                                controller: TextEditingController(),
                                inputType: TextInputType.multiline,
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text("No data found"));
                        }
                      }),
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
                                    return BottomNavigationMenu(isPatient, initialIndex: 2,);
                                  }),
                                ),
                              ),
                          false,
                          true,
                          false)),
                  Expanded(
                      child: Button("Save Changes", () => saveProfile(), true,
                          true, false)),
                ],
              ),
            ])),
      ),
    );
  }

  void saveProfile(){}

  Widget conditionField() {
    return Column(
      spacing: 20,
      children: [
        Input(
          header: "Medical Conditions",
          placeholder: "Add new condition",
          isDisabled: false,
          useIcon: Icon(null),
          controller: conditionController,
          inputType: TextInputType.multiline,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: Button(
                    "Reset Condition", () => resetCondition(), false, false, true)),
            Expanded(
                child: Button("Add Condition", () => addCondition(), true, false, true)),
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
              useIcon: Icon(null),
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
                child:
                    Button("Reset Allergy", () => resetAllergy(), false, false, true)),
            Expanded(
                child: Button("Add Allergy", () => addAllergy(), true, false, true)),
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

  Future<Doctor> getDoctor() async {
    User user = await getUser();
    String userID = user.userID;

    final response = await DoctorService().getDoctorByUserID(userID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data); // TODO Change to array of object
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
