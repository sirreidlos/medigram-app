import 'package:medigram_app/models/consultation/consent.dart';

class CDiagnosis {
  final String diagnosis;
  final String icdCode;
  final String severity;

  CDiagnosis({
    required this.diagnosis,
    required this.icdCode,
    required this.severity,
  });
  Map<String, dynamic> toJson() {
    return {'diagnosis': diagnosis, 'icd_code': icdCode, 'severity': severity};
  }
}

class CPrescription {
  final String drugName;
  final double dosesInMg;
  final double regimenPerDay;
  final double quantityPerDose;
  final String instruction;

  CPrescription({
    required this.drugName,
    required this.dosesInMg,
    required this.regimenPerDay,
    required this.quantityPerDose,
    required this.instruction,
  });
  Map<String, dynamic> toJson() {
    return {
      'drug_name': drugName,
      'doses_in_mg': dosesInMg,
      'regimen_per_day': regimenPerDay,
      'quantity_per_dose': quantityPerDose,
      'instruction': instruction,
    };
  }
}

class PostConsult {
  final Consent consent;
  final String userID;
  final CDiagnosis diagnosis;
  final List<String> symptoms;
  final CPrescription prescription;

  PostConsult({
    required this.consent,
    required this.userID,
    required this.diagnosis,
    required this.symptoms,
    required this.prescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'consent': consent.toJson(),
      'user_id': userID,
      'diagnoses': [
        diagnosis.toJson(),
      ], // Assuming it's a single diagnosis wrapped in a list
      'symptoms': symptoms,
      'prescriptions': [
        prescription.toJson(),
      ], // Assuming it's a single prescription wrapped in a list
    };
  }
}
