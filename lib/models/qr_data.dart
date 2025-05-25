import 'package:medigram_app/models/consultation/consent.dart';

class QrData {
  final Consent consent;
  final String userID;

  QrData({required this.consent, required this.userID});

  factory QrData.fromJson(Map<String, dynamic> json) {
  return QrData(
    consent: Consent.fromJson(json['consent']),
    userID: json["user_id"],
  );
}

  Map<String, dynamic> toJson() => {
    "consent": consent.toJson(),
    "user_id": userID,
  };
}