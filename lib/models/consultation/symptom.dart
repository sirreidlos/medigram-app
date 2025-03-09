class Symptom {
  final String symptomID;
  final String consultationID;
  final String symptom;

  Symptom({
    required this.symptomID,
    required this.consultationID,
    required this.symptom,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      symptomID: json["symptom_id"],
      consultationID: json["consultation_id"],
      symptom: json["symptom"],
    );
  }
}
