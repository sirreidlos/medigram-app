class Allergy {
  final String allergyID;
  final String userID;
  final String allergen;
  final String severity;

  Allergy({
    required this.allergyID,
    required this.userID,
    required this.allergen,
    required this.severity,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      allergyID: json["allergy_id"],
      userID: json["user_id"],
      allergen: json["allergen"],
      severity: json["severity"],
    );
  }
}
