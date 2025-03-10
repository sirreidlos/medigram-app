import 'package:flutter/material.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/constants/style.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

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
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Consultations History", style: header2),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
              RecordCard(
                title: "Brian Wong",
                subtitle: "Doofenshmirtz Evil Incorporated",
                info1: "00/00/00",
                info2: "12:22",
                isMed: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
