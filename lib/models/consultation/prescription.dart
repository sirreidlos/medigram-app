class Prescription {
  final String prescriptionID;
  final String consultationID;
  final String drugName;
  final double dosesInMg;
  final double regimenPerDay;
  final double quantityPerDose;
  final String instruction;

  Prescription({
    required this.prescriptionID,
    required this.consultationID,
    required this.drugName,
    required this.dosesInMg,
    required this.regimenPerDay,
    required this.quantityPerDose,
    required this.instruction,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescriptionID: json["prescription_id"],
      consultationID: json["consultation_id"],
      drugName: json["drug_name"],
      dosesInMg: json["doses_in_mg"],
      regimenPerDay: json["regimen_per_day"],
      quantityPerDose: json["quantity_per_dose"],
      instruction: json["instruction"],
    );
  }
}
