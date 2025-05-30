import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/history.dart';
import 'package:medigram_app/components/scan_qr.dart';
import 'package:medigram_app/components/show_qr.dart';
import 'package:medigram_app/constants/user_status.dart';
import 'package:medigram_app/models/doctor/doctor.dart';
import 'package:medigram_app/models/doctor/location.dart';
import 'package:medigram_app/models/nonce.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/page/medicine_claim.dart';
import 'package:medigram_app/page/reminder.dart';
import 'package:medigram_app/page/set_profile.dart';
import 'package:medigram_app/services/doctor_service.dart';
import 'package:medigram_app/services/nonce_service.dart';
import 'package:medigram_app/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLocationID = "";
  String selectedLocationName = "Select Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                screenPadding,
                topScreenPadding,
                screenPadding,
                screenPadding,
              ),
              decoration: BoxDecoration(
                color: Color(secondaryColor1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: FutureBuilder(
                  future: SharedPrefsHelper.getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      bool isPatient = snapshot.data!;
                      return Column(
                        spacing: 30,
                        children: [
                          Row(
                            children: [
                              FutureBuilder(
                                  future: getUser(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      return Text(
                                        "Hello, ${isPatient ? "" : "Dr. "}${snapshot.data!.name}",
                                        style: title,
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No data found"));
                                    }
                                  }),
                              Spacer(),
                              FutureBuilder(
                                future: getDoctor(),
                                builder: (context, snapshot) {
                                  bool isEnabled = snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData &&
                                      snapshot.data != null;

                                  return IconButton(
                                    icon: Icon(
                                      Icons.swap_horiz_rounded,
                                    ),
                                    onPressed: isEnabled
                                        ? () async {
                                            await SharedPrefsHelper
                                                .saveUserRole(!isPatient);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    BottomNavigationMenu(
                                                        !isPatient),
                                              ),
                                            );
                                          }
                                        : null,
                                  );
                                },
                              ),
                              Icon(Icons.notifications),
                            ],
                          ),
                          mainFeature(context, isPatient),
                          isPatient ? medsHandler(context) : Container(),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                  }),
            ),
            FutureBuilder(
                future: SharedPrefsHelper.getUserRole(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    bool isPatient = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(screenPadding),
                      child: Column(
                        spacing: 30,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // isPatient ? medsReminder() : Container(), //TODO Notification only
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                "Recent Consultations",
                                style: header2,
                              ),
                              RecordHistory(isPatient: isPatient, topN: true)
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text("No data"));
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget mainFeature(BuildContext context, bool isPatient) {
    return Column(
      spacing: isPatient ? 0 : 10,
      children: [
        isPatient
            ? SizedBox(
                height: 0,
              )
            : SizedBox(
                width: double.infinity,
                child: InkWell(
                    onTap: () {
                      showLocation();
                    },
                    child: Row(children: [
                      Icon(Icons.location_on),
                      Expanded(
                          child: Text(
                        selectedLocationName,
                        style: title,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ]))),
        SizedBox(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            onPressed: () async {
              if (isPatient) {
                final response = await NonceService().requestNonce();
                // TODO error handle, show toast or something if it's not 200 OK
                Map<String, dynamic> data = jsonDecode(response.body);
                Nonce nonce = Nonce.fromJson(data); // get code from data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return ShowQr(nonce, true);
                    }),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return ScanQR(selectedLocationID);
                    }),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(primaryColor1),
              padding: EdgeInsets.all(screenPadding),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              spacing: screenPadding,
              children: [
                Image.asset(
                  'assets/icons/start-consultation.png',
                  width: 50,
                ),
                Text(
                  isPatient ? "Start Consultation" : "Scan Patient Data",
                  style: header1,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> showLocation() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Select Location"),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.maxFinite,
                child: FutureBuilder(
                    future: getDoctor(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        Doctor doctor = snapshot.data!;
                        List<PracticeLocation> listLocation = doctor.locations;
                        return Column(
                            children:
                                List.generate(listLocation.length, (index) {
                          final loc = listLocation[index];
                          return RadioListTile(
                              title: Text(
                                loc.practiceAddress,
                                style: body,
                                maxLines: null,
                              ),
                              value: loc.locationID,
                              groupValue: selectedLocationID,
                              onChanged: (value) {
                                setState(() {
                                  selectedLocationID = loc.locationID;
                                  selectedLocationName = loc.practiceAddress;
                                });
                                Navigator.pop(context);
                              });
                        }));
                      } else {
                        return Center(child: Text("No data found"));
                      }
                    }),
              ));
        });
  }

  Widget medsHandler(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    return MedicineClaim();
                  }),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(primaryColor2),
              padding: EdgeInsets.all(screenPadding),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              spacing: 10,
              children: [
                Image.asset(
                  'assets/icons/meds-claim.png',
                  width: 50,
                ),
                Text(
                  "Meds Claim",
                  style: header1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return ReminderPage();
              })));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(secondaryColor2),
              padding: EdgeInsets.only(
                  left: screenPadding - 5,
                  right: screenPadding - 5,
                  top: screenPadding,
                  bottom: screenPadding),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              spacing: 10,
              children: [
                Image.asset(
                  'assets/icons/meds-regimen.png',
                  width: 50,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Meds Regimen",
                    style: header1,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget medsReminder() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(secondaryColor2),
          padding: EdgeInsets.all(screenPadding),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          spacing: screenPadding,
          children: [
            Image.asset(
              'assets/icons/meds-reminder.png',
              width: 50,
            ),
            Text(
              "Medication Reminder",
              style: header1,
            ),
          ],
        ),
      ),
    );
  }

  Future<UserDetail> getUser() async {
    final response = await UserService().getOwnDetail();
    Map<String, dynamic> data = jsonDecode(response.body);
    UserDetail user = UserDetail.fromJson(data);
    return user;
  }

  Future<Doctor> getDoctor() async {
    UserDetail user = await getUser();
    String userID = user.userID;

    final response = await DoctorService().getDoctorByUserID(userID);
    Map<String, dynamic> data = jsonDecode(response.body);
    Doctor doctor = Doctor.fromJson(data);
    return doctor;
  }
}
