class Location {
  final String locationID;
  final String doctorID;
  final String practicePermit;
  final String practiceAddress;
  final DateTime approvedAt;
  final DateTime createdAt;

  Location({
    required this.locationID,
    required this.doctorID,
    required this.practicePermit,
    required this.practiceAddress,
    required this.approvedAt,
    required this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        locationID: json["location_id"],
        doctorID: json["doctor_id"],
        practiceAddress: json["practice_address"],
        practicePermit: json["practice_permit"],
        approvedAt: DateTime.parse(json["approved_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        );
  }
}
