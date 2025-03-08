import 'package:flutter/material.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/utils/style.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ConsultForm extends StatelessWidget {
  const ConsultForm(this.barcode, {super.key});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: 559,
          padding: EdgeInsets.fromLTRB(
            screenPadding,
            topScreenPadding,
            screenPadding,
            screenPadding,
          ),
          child: Column(
            spacing: 15,
            children: [
              PopupHeader(context, "Prescription Form"),
              Input(
                header: "Name",
                placeholder: "Jane Doe",
                initValue: "Jane Doe",
                isDisabled: true,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Input(
                      header: "Date of Birth",
                      placeholder: "7 July 1996",
                      initValue: "7 July 1996",
                      isDisabled: true,
                      useIcon: Icon(null),
                      inputType: TextInputType.text,
                    ),
                  ),
                  Expanded(
                    child: Input(
                      header: "Gender",
                      placeholder: "Female",
                      initValue: "Female",
                      isDisabled: true,
                      useIcon: Icon(null),
                      inputType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              LineDivider(),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Input(
                      header: "Body Height (cm)",
                      placeholder: "165",
                      initValue: "165",
                      isDisabled: true,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Input(
                      header: "Body Weight(kg)",
                      placeholder: "65",
                      initValue: "65",
                      isDisabled: true,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Input(
                header: "Allergy",
                placeholder: "Penicillin Soy Bee",
                initValue: "Penicillin Soy Bee",
                isDisabled: true,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Input(
                header: "Medical Conditions",
                placeholder: "ADHD AUTISM",
                initValue: "ADHD AUTISM",
                isDisabled: true,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              LineDivider(),
              Input(
                header: "Diagnoses",
                placeholder: "Low blood pressure, dehydrated, ear infection",
                initValue: "Low blood pressure, dehydrated, ear infection",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Input(
                header: "Symptoms",
                placeholder: "Mouth ulcers, chapped lips, ringing ear, fainted",
                initValue: "Mouth ulcers, chapped lips, ringing ear, fainted",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              LineDivider(),
              Input(
                header: "Medicine:",
                placeholder: "",
                initValue: "",
                isDisabled: true,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Input(
                header: "Drug Name",
                placeholder: "Penicillin",
                initValue: "Penicillin",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Input(
                      header: "Doses (mg)",
                      placeholder: "165",
                      initValue: "165",
                      isDisabled: false,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Input(
                      header: "Regimen (per day)",
                      placeholder: "3",
                      initValue: "3",
                      isDisabled: false,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Input(
                header: "Quantity (per dose)",
                placeholder: "21",
                initValue: "21",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.number,
              ),
              Input(
                header: "How to Consume",
                placeholder: "After meal",
                initValue: "After meal",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Button("Cancel", () {}, false)),
                  Expanded(child: Button("Add", () {}, true)),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: RecordCard(
                      title: "Amoxicillin 500 mg",
                      subtitle: "3 times/day, after meal",
                      info1: "21x",
                      info2: "",
                      isMed: true,
                    ),
                  ),
                ],
              ),
              WarningCard("Make sure your diagnoses and prescription is suitable for the patient!")
            ],
          ),
        ),
      ),
    );
  }
}
