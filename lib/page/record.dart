import 'package:flutter/material.dart';
import 'package:medigram_app/components/history.dart';
import 'package:medigram_app/constants/style.dart';
import 'package:medigram_app/constants/user_status.dart';

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
              FutureBuilder(
                  future: getStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return RecordHistory(snapshot.data!, false);
                    } else {
                      return Center(child: Text("No data found"));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> getStatus() async {
  return await SharedPrefsHelper.getUserRole();
}
