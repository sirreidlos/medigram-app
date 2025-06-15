import 'package:medigram_app/models/doctor/location.dart';

class Doctor {
  final String doctorID;
  final String userID;
  final String name;
  final DateTime createdAt;
  final List<PracticeLocation>? locations;

  Doctor({
    required this.doctorID,
    required this.userID,
    required this.name,
    required this.createdAt,
    this.locations,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        doctorID: json["doctor_id"],
        userID: json["user_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        locations: json["locations"] == null
            ? null
            : ((json["locations"] as List)
                .map((loc) =>
                    PracticeLocation.fromJson(loc as Map<String, dynamic>))
                .toList()));
  }
}
