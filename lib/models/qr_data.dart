import 'package:medigram_app/models/consultation/consent.dart';

class QrData {
  final Consent consent;
  final String userID;
  final DateTime expiredAt;

  QrData({required this.consent, required this.userID, required this.expiredAt});

  factory QrData.fromJson(Map<String, dynamic> json) {
  return QrData(
    consent: Consent.fromJson(json['consent']),
    userID: json["user_id"],
    expiredAt: DateTime.parse(json["expired_at"])
  );
}

  Map<String, dynamic> toJson() => {
    "consent": consent.toJson(),
    "user_id": userID,
    "expired_at": expiredAt.toString()
  };
}