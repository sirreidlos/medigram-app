class Doctor {
  final String doctorID;
  final String userID;
  final String praticePermit;
  final String practiceAddress;
  final bool approved;
  final DateTime approvedAt;

  Doctor({
    required this.doctorID,
    required this.userID,
    required this.praticePermit,
    required this.practiceAddress,
    required this.approved,
    required this.approvedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorID: json["doctor_id"],
      userID: json["user_id"],
      praticePermit: json["practice_permit"],
      practiceAddress: json["practice_address"],
      approved: json["approved"],
      approvedAt: json["approved_at"],
    );
  }
}
