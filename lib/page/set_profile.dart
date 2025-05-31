import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/services/user_service.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  DateTime startDate = DateTime.now();
  String genderSelected = "Female (F)";

  List<String> genderList = [
    "Female (F)",
    "Male (M)",
  ];

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

  void genderController(String newValue) {
    setState(() {
      genderSelected = newValue;
    });
  }

  void addAllergy() {
    setState(() {
      listAllergy.add(Allergy(
          allergyID: "",
          userID: "",
          allergen: allergyController.text,
          severity: severitySelected.split(" ")[0].toUpperCase()));
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
            spacing: 15,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Setup Your Profile",
                  style: header2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Input(
                header: "Name",
                placeholder: "Your full name",
                isDisabled: false,
                controller: nameController,
                inputType: TextInputType.multiline,
              ),
              Input(
                header: "NIK",
                placeholder: "Your identity number must be 16 digits",
                isDisabled: false,
                controller: nikController,
                inputType: TextInputType.number,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Input(
                          header: "Age",
                          placeholder:
                              DateFormat("dd MMMM yyyy").format(startDate),
                          isDisabled: false,
                          controller: TextEditingController(),
                          inputType: TextInputType.none,
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
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(secondaryColor1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gender",
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        SizedBox(
                          child: DropdownButton(
                              isExpanded: true,
                              value: genderSelected,
                              items: genderList.map((String gender) {
                                return DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (String? newValue) =>
                                  genderController(newValue!)),
                        )
                      ])),
              Input(
                header: "Height (cm)",
                placeholder: "Your height in cm unit",
                isDisabled: false,
                controller: heightController,
                inputType: TextInputType.number,
              ),
              Input(
                header: "Weight (kg)",
                placeholder: "Your body weight in kg unit",
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
              SizedBox(
                  width: double.infinity,
                  child: Button(
                      "Save Changes", () => saveProfile(), true, true, false)),
            ],
          )),
    ));
  }

  Future saveProfile() async {
    int nik = int.parse(nikController.text);
    String name = nameController.text;
    DateTime dob = startDate;
    String gender = genderSelected.substring(0, 1).toUpperCase();
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    try {
      await UserService().putOwnDetail(nik, name, dob, gender);
      await UserService().postOwnMeasurements(weight, height);

      for (var allergyID in deletedAllergy) {
        if (allergyID == "") continue;
        await UserService().deleteAllergy(allergyID);
      }

      for (var conditionID in deletedCondition) {
        if (conditionID == "") continue;
        await UserService().deleteConditions(conditionID);
      }

      for (var allergy in listAllergy) {
        if (allergy.allergyID != "") continue;
        await UserService().postOwnAllergy(allergy.allergen, allergy.severity);
      }
      for (var condition in listConditions) {
        if (condition.conditionsID != "") continue;
        await UserService().postOwnConditions(condition.conditions);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) {
            return BottomNavigationMenu(true);
          }),
        ),
      );
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Network Error!"),
              content: Text(
                  'We\'re sorry, there is some problem with the system. Try again later.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) {
                          return SetProfile();
                        }),
                      ),
                    );
                  },
                ),
              ],
            );
          });
    }
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

  Future<void> displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(secondaryColor1), // Warna header & tombol OK
              onPrimary: Colors.black, // Warna teks di header
              onSurface: Colors.black, // Warna teks di tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Color(secondaryColor2), // Warna tombol CANCEL & OK
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
}
