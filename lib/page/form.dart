import 'package:flutter/material.dart';
import 'package:medigram_app/components/button.dart';
import 'package:medigram_app/components/input.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/utils/line.dart';
import 'package:medigram_app/constants/style.dart';

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
              SizedBox(
                width: double.infinity,
                child: Text("Patient Profile", style: header2),
              ),
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
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Input(
                      header: "Height (cm)",
                      placeholder: "165",
                      initValue: "165",
                      isDisabled: true,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Input(
                      header: "Weight (kg)",
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
              SizedBox(
                width: double.infinity,
                child: Text("Consultation", style: header2),
              ),
              Input(
                header: "Diagnoses",
                placeholder: "Your patient diagnoses",
                initValue: "",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Input(
                header: "Symptoms",
                placeholder: "Your patient symptoms",
                initValue: "",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              LineDivider(),
              SizedBox(
                width: double.infinity,
                child: Text("Medicine", style: header2),
              ),
              Input(
                header: "Drug Name",
                placeholder: "Medicine for your patient",
                initValue: "",
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
                      placeholder: "Doses in mg",
                      initValue: "",
                      isDisabled: false,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Input(
                      header: "Daily Regimen",
                      placeholder: "Per day",
                      initValue: "",
                      isDisabled: false,
                      useIcon: Icon(null),
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Input(
                header: "Quantity (/dose)",
                placeholder: "Per dose",
                initValue: "",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.number,
              ),
              Input(
                header: "Instruction",
                placeholder: "How to consume",
                initValue: "",
                isDisabled: false,
                useIcon: Icon(null),
                inputType: TextInputType.text,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Button("Reset", () {}, false, false, true)),
                  Expanded(child: Button("Add", () {}, true, false, true)),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: RecordCard(
                      title: "Penicillin 165 mg",
                      subtitle: "3 times/day, after meal",
                      info1: "21x",
                      info2: "",
                      isMed: true,
                    ),
                  ),
                ],
              ),
              WarningCard(
                "Make sure your diagnoses and prescription are suitable for the patient!",
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: Button("Cancel", () {}, false, true, false)),
                  Expanded(child: Button("Prescribe", () {}, true, true, false)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
