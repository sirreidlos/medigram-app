class UserMeasurement {
  final String measurementID;
  final String userID;
  final double heightInCm;
  final double weightInKg;
  final DateTime measuredAt;

  UserMeasurement({
    required this.measurementID,
    required this.userID,
    required this.heightInCm,
    required this.weightInKg,
    required this.measuredAt,
  });

  factory UserMeasurement.fromJson(Map<String, dynamic> json) {
    return UserMeasurement(
      measurementID: json["measurement_id"],
      userID: json["user_id"],
      heightInCm: json["height_in_cm"],
      weightInKg: json["weight_in_kg"],
      measuredAt: DateTime.parse(json["measured_at"]),
    );
  }
}
