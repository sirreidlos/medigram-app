class Consultation {
  final String consultationID;
  final String doctorID;
  final String userID;
  final String locationID;
  final String symptoms;
  final DateTime createdAt;
  final bool reminded;

  Consultation({
    required this.consultationID,
    required this.doctorID,
    required this.userID,
    required this.locationID,
    required this.symptoms,
    required this.createdAt,
    required this.reminded,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      consultationID: json["consultation_id"],
      doctorID: json["doctor_id"],
      userID: json["user_id"],
      locationID: json["location_id"],
      symptoms: json["symptoms"],
      createdAt: DateTime.parse(
        json["created_at"],
      ),
      reminded: json["reminded"],
    );
  }
}
