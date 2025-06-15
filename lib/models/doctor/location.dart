class PracticeLocation {
  final String locationID;
  final String doctorID;
  final String practicePermit;
  final String practiceAddress;
  final DateTime? approvedAt;
  final String? approvedBy;
  final DateTime createdAt;

  PracticeLocation({
    required this.locationID,
    required this.doctorID,
    required this.practicePermit,
    required this.practiceAddress,
    this.approvedAt,
    this.approvedBy,
    required this.createdAt,
  });

  factory PracticeLocation.fromJson(Map<String, dynamic> json) {
    return PracticeLocation(
      locationID: json["location_id"],
      doctorID: json["doctor_id"],
      practiceAddress: json["practice_address"],
      practicePermit: json["practice_permit"],
      approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
      approvedBy: json["approved_by"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
