class PracticeLocation {
  final String locationID;
  final String doctorID;
  final String practicePermit;
  final String practiceAddress;
  final DateTime approvedAt;
  final DateTime createdAt;

  PracticeLocation({
    required this.locationID,
    required this.doctorID,
    required this.practicePermit,
    required this.practiceAddress,
    required this.approvedAt,
    required this.createdAt,
  });

  factory PracticeLocation.fromJson(Map<String, dynamic> json) {
    return PracticeLocation(
        locationID: json["location_id"],
        doctorID: json["doctor_id"],
        practiceAddress: json["practice_address"],
        practicePermit: json["practice_permit"],
        approvedAt: DateTime.parse(json["approved_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        );
  }
}
