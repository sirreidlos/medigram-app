import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/models/consultation/prescription.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/medicine_claim.dart';
import 'package:medigram_app/services/consultation_service.dart';

class PrescriptionInfo extends StatefulWidget {
  const PrescriptionInfo(this.consultationID, {super.key});
  final String consultationID;

  @override
  State<PrescriptionInfo> createState() => _PrescriptionInfoState();
}

class _PrescriptionInfoState extends State<PrescriptionInfo> {
  late Future<List<Prescription>> listPres;
  List<bool> checkStatus = [];

  @override
  void initState() {
    super.initState();
    listPres = getPrescription(widget.consultationID);
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
            spacing: screenPadding,
            children: [
              PopupHeader(MaterialPageRoute(
                builder: ((context) {
                  return MedicineClaim();
                }),
              ), "Prescription Info", false),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Select medicine to purchase",
                  style: header2,
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<Prescription>>(
                      future: listPres,
                      builder: (builder, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Prescription> listPres = snapshot.data!;
                          if (checkStatus.isEmpty) {
                            checkStatus =
                                List<bool>.filled(listPres.length, true);
                          }
                          return Column(
                            spacing: 10,
                            children: List.generate(listPres.length, (index) {
                              final p = listPres[index];
                              if(p.purchasedAt != null) checkStatus[index] = false;
                              return Row(
                                spacing: 10,
                                children: [
                                  SizedBox(
                                      width: 20,
                                      child: Checkbox(
                                          tristate: p.purchasedAt == null
                                              ? false
                                              : true,
                                          isError: p.purchasedAt == null
                                              ? false
                                              : true,
                                          value: p.purchasedAt == null
                                              ? checkStatus[index]
                                              : null,
                                          onChanged: p.purchasedAt != null
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    checkStatus[index] = value!;
                                                  });
                                                })),
                                  Expanded(
                                      child: RecordCard(
                                    title: p.drugName,
                                    subtitle:
                                        "${p.regimenPerDay} times/day, ${p.instruction}",
                                    info1: "${p.quantityPerDose}x",
                                    info2: "",
                                    isMed: true,
                                  ))
                                ],
                              );
                            }),
                          );
                        } else {
                          return Center(child: Text("No data"));
                        }
                      })),
              WarningCard(
                  "Make sure the pharmacist that mark this as purchased."),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => updatePrescription(
                        widget.consultationID, await listPres),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(secondaryColor2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Color((0xffffff))),
                    ),
                    child: Text("Mark as Purchased", style: header2),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatePrescription(
      String consultationID, List<Prescription> listPres) async {
    bool success = true;
    for (final (i, stat) in checkStatus.indexed) {
      if (stat) {
        final pres = listPres[i];
        final response =
            await ConsultationService().putPrescription(pres.prescriptionID);
        if (response.statusCode != 200) {
          success = false;
          break;
        }
      }
    }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(success
                ? 'Prescription Purchased Successfully!'
                : "Network Error!"),
            content: Text(success
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
                        return MedicineClaim();
                      }),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<List<Prescription>> getPrescription(String consultationID) async {
    final response =
        await ConsultationService().getPrescription(consultationID);
    final List data = jsonDecode(response.body);

    return data.map((e) => Prescription.fromJson(e)).toList();
  }
}
