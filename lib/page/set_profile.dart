import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/constants/style.dart';
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

  DateTime startDate = DateTime.now();
  String genderSelected = "Female (F)";

  List<String> genderList = [
    "Female (F)",
    "Male (M)",
  ];

  void genderController(String newValue) {
    setState(() {
      genderSelected = newValue;
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
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Input(
                      header: "Age",
                      placeholder: DateFormat("dd MMMM yyyy").format(startDate),
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
                      Icon(Icons.calendar_month, color: Color(secondaryColor2)),
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
                                    return BottomNavigationMenu(true);
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
            ],
          )),
    ));
  }

  Future saveProfile() async {
    int nik = int.parse(nikController.text);
    String name = nameController.text;
    DateTime dob = startDate;
    String gender = genderSelected.substring(0, 1).toUpperCase();

    final response = await UserService().putOwnDetail(nik, name, dob, gender);
    debugPrint(response.body);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile set successfully!'),
            content: Text('Stay Healthy!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Go to app'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return BottomNavigationMenu(true);
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
