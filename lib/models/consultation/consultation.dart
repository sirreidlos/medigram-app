class Consultation {
  final String consultationID;
  final String doctorID;
  final String userID;

  Consultation({
    required this.consultationID,
    required this.doctorID,
    required this.userID,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      consultationID: json["consultation_id"],
      doctorID: json["doctor_id"],
      userID: json["user_id"],
    );
  }
}
