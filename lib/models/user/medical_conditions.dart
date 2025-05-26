class MedicalConditions {
  final String conditionsID;
  final String userID;
  final String conditions;

  MedicalConditions(
      {required this.conditionsID,
      required this.userID,
      required this.conditions});

  factory MedicalConditions.fromJson(Map<String, dynamic> json) {
    return MedicalConditions(
      conditionsID: json["condition_id"],
      userID: json["user_id"],
      conditions: json["condition"],
    );
  }
}
