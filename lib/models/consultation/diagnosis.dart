class Diagnosis {
  final String diagnosisID;
  final String consultationID;
  final String diagnosis;
  final String icdCode;
  final String severity;

  Diagnosis({
    required this.diagnosisID,
    required this.consultationID,
    required this.diagnosis,
    required this.icdCode,
    required this.severity,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      diagnosisID: json["diagnosis_id"],
      consultationID: json["consultation_id"],
      diagnosis: json["diagnosis"],
      icdCode: json["icd_code"],
      severity: json["severty"],
    );
  }
}
