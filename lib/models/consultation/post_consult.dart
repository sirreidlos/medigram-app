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
  final String consent;
  final String userID;
  final List<CDiagnosis> diagnosis;
  final List<String> symptoms;
  final List<CPrescription> prescription;

  PostConsult({
    required this.consent,
    required this.userID,
    required this.diagnosis,
    required this.symptoms,
    required this.prescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'consent': consent,
      'user_id': userID,
      'diagnoses':  diagnosis,
      'symptoms': symptoms,
      'prescriptions': prescription
    };
  }
}
