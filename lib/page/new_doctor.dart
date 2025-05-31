import 'package:flutter/material.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/services/doctor_service.dart';

class NewDoctor extends StatefulWidget {
  const NewDoctor({super.key});

  @override
  State<NewDoctor> createState() => _NewDoctorState();
}

class _NewDoctorState extends State<NewDoctor> {
  final TextEditingController permitController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
            children: [
              PopupHeader(MaterialPageRoute(
                builder: (context) {
                  return BottomNavigationMenu(false, initialIndex: 2);
                },
              ), "Add New Practice", true),
              SizedBox(
                width: double.infinity,
                child: Text("Input your practice detail", style: header2),
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
              WarningCard(
                  "Make sure your practice permit is valid! The verification process will take 2 - 3 work days."),
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
                                          true,
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
                      child: Button("Add Practice", () {
                    savePractice();
                  }, true, true, false)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> savePractice() async {
    final response = await DoctorService().postOwnDoctor();
    String permit = permitController.text;
    String address = addressController.text;

    final responseAdd = await DoctorService().postOwnPractice(permit, address);
    final code = responseAdd.statusCode;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                code == 201 ? 'Changes saved successfully!' : "Network Error!"),
            content: Text(code == 201
                ? 'You are doing a great work!'
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
                          true,
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
}
