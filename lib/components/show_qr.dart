import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cryptography/cryptography.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/record_card.dart';
import 'package:medigram_app/components/warning.dart';
import 'package:medigram_app/models/nonce.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_measurement.dart';
import 'package:medigram_app/services/auth_service.dart';
import 'package:medigram_app/services/nonce_service.dart';
import 'package:medigram_app/services/secure_storage.dart';
import 'package:medigram_app/services/user_service.dart';
import 'package:medigram_app/utils/qr_image.dart';
import 'package:medigram_app/constants/style.dart';

class ShowQr extends StatelessWidget {
  const ShowQr(this.nonce, this.isConsult, {super.key});

  final Nonce nonce;
  final bool isConsult;

  Future<void> regenerateQR(BuildContext context) async {
    final response = await NonceService().requestNonce();
    Map<String, dynamic> data = jsonDecode(response.body);
    Nonce newNonce = Nonce.fromJson(data);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => ShowQr(newNonce, isConsult)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: () async {
          // TODO don't call login here, this is just provisional
          // await AuthService().login("test@example.com", "test");
          return signConsent(nonce.nonce);
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final signature = snapshot.data!;
            return SingleChildScrollView(
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
                    child: Column(
                      children: [
                        PopupHeader(
                          context,
                          isConsult ? "Consultation" : "Medicine Claim",
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: screenPadding,
                            bottom: screenPadding,
                          ),
                          child: Column(
                            spacing: 15,
                            children: [
                              Text(
                                "QR code below will expire at ${DateFormat.yMMMMEEEEd().add_jms().format(nonce.expirationDate.toLocal())}",
                                style: content,
                              ),
                              Center(child: QRImage(signature)),
                              InkWell(
                                child: Text(
                                  "Regenerate QR Code",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    color: Color(secondaryColor2),
                                  ),
                                ),
                                onTap: () => regenerateQR(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(screenPadding),
                    child: Column(
                      spacing: 50,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your ${isConsult ? "Profile" : "Consultation"}",
                              style: header2,
                            ),
                            showProfile(),
                          ],
                        ),
                        WarningCard(
                          isConsult
                              ? "Make sure your physician already asks for your information!"
                              : "You can only purchase this prescription once!",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // no data (unlikely)
            return Center(child: Text("No signature found"));
          }
        },
      ),
    );
  }
}

DateTime expiredTime() {
  DateTime current = DateTime.now();
  Duration duration = Duration(minutes: 5);
  DateTime expired = current.add(duration);

  return expired;
}

Future<String> signConsent(String nonce) async {
  String? pk = await SecureStorageService().read('private_key');
  String? deviceId = await SecureStorageService().read('device_id');
  if (pk == null || deviceId == null) {
    // TODO handle error better
    throw Exception("not signed in");
  }

  final keyBytes = base64.decode(pk);

  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(keyBytes.sublist(0, 32));

  final message = jsonEncode([deviceId, nonce]);
  final messageBytes = utf8.encode(message);

  final signature = await algorithm.sign(messageBytes, keyPair: keyPair);
  final base64Signature = base64.encode(signature.bytes);

  return base64Signature;
}

Widget showProfile() {
  UserDetail user = getUserDetail() as UserDetail;
  UserMeasurement userDetail = getUserMeasurement() as UserMeasurement;
  return RecordCard(
    title: user.name,
    subtitle:  "${user.gender} | ${user.dob} years old",
    info1: "${userDetail.heightInCm} cm",
    info2: "${userDetail.weightInKg} kg",
    isMed: false,
  );
}

Future<UserDetail> getUserDetail() async {
  final response = await UserService().getUserDetail();
  Map<String, dynamic> data = jsonDecode(response.body);
  UserDetail user = UserDetail.fromJson(data);
  return user;
}

Future<UserMeasurement> getUserMeasurement() async {
  final response = await UserService().getMeasure();
  Map<String, dynamic> data = jsonDecode(response.body);
  UserMeasurement user = UserMeasurement.fromJson(data);
  return user;
}
