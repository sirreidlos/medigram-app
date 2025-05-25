import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cryptography/cryptography.dart';
import 'package:medigram_app/components/popup_header.dart';
import 'package:medigram_app/components/qr_profile.dart';
import 'package:medigram_app/models/consultation/consent.dart';
import 'package:medigram_app/models/nonce.dart';
import 'package:medigram_app/models/qr_data.dart';
import 'package:medigram_app/services/nonce_service.dart';
import 'package:medigram_app/services/secure_storage.dart';
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
      body: FutureBuilder<QrData>(
        future: () async {
          return signConsent(nonce.nonce);
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final consent = snapshot.data!;

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
                                "QR code below will expire at ${DateFormat("dd MMMM yyyy HH:mm:ss").format(nonce.expirationDate)}",
                                style: content,
                              ),
                              Center(child: QRImage(consent)),
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
                  QRProfile(isConsult)
                ],
              ),
            );
          } else {
            return Center(child: Text("No signature found"));
          }
        },
      ),
    );
  }
}

Future<QrData> signConsent(String nonce) async {
  String? pk = await SecureStorageService().read('private_key');
  String? deviceId = await SecureStorageService().read('device_id');
  String? userId = await SecureStorageService().read('user_id');
  if (pk == null || deviceId == null || userId == null) {
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

  Consent consent = Consent(signerDeviceID: deviceId, nonce: nonce, signature: base64Signature);
  QrData data = QrData(consent: consent, userID: userId);
  return data;
}

