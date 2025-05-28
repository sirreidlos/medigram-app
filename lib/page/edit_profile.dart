import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_full.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/home.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/utils/dob_age.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<UserFull> userData;
  bool isPatient = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  DateTime startDate = DateTime.now();

  List<String> genderList = [
    "Female (F)",
    "Male (M)",
  ];
  String genderSelected = "";

  @override
  void initState() {
    super.initState();
    userData = fetchFullPatientData();
    getPatientStatus();
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
    final userDetail = await getUserDetail();
    final userMeasure = await getUserMeasurement();
    final listAllergy = await getUserAllergy();
    final listCondition = await getUserConditions();

    return UserFull(
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
                          UserDetail user = snapshot.data!.userDetail;
                          UserMeasurement userDetail =
                              snapshot.data!.userMeasurement;
                          List<Allergy> allergy = snapshot.data!.listAllergy;
                          List<MedicalConditions> conditions =
                              snapshot.data!.listConditions;
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
                                  return BottomNavigationMenu(isPatient, initialIndex: 2,);
                                }),
                              ), "Edit Profile", true),
                              Input(
                                header: "Name",
                                placeholder: user.name,
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: nameController,
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
                                    color: Color(secondaryColor1)
                                        .withValues(alpha: 0.65),
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
                                children: [
                                  Input(
                                    header: "Allergy*",
                                    placeholder: allergy.isEmpty
                                        ? "-"
                                        : allergy
                                            .map((a) =>
                                                "${a.allergen} (${getSeverity(a.severity)})")
                                            .join(", "),
                                    isDisabled: false,
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
                                        .map((c) => c.conditions)
                                        .join(", "),
                                isDisabled: false,
                                useIcon: Icon(null),
                                controller: TextEditingController(),
                                inputType: TextInputType.multiline,
                              ),
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
                                header: doctor.praticePermit,
                                placeholder: doctor.practiceAddress,
                                isDisabled: false,
                                useIcon: Icon(doctor.approved
                                    ? Icons.verified_user_outlined
                                    : Icons.pending_actions_rounded),
                                controller: TextEditingController(),
                                inputType: TextInputType.multiline,
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text("No data found"));
                        }
                      }),
            ])),
      ),
    );
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
    UserDetail user = await getUser();
    String userID = user.userID;

    final response = await DoctorService().getDoctorByUserID(userID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data); // TODO Change to array of object
    return doctor;
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
