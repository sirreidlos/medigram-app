import 'package:medigram_app/models/user/allery.dart';
import 'package:medigram_app/models/user/medical_conditions.dart';
import 'package:medigram_app/models/user/user_detail.dart';
import 'package:medigram_app/models/user/user_measurement.dart';

class UserFull {
  final UserDetail userDetail;
  final UserMeasurement userMeasurement;
  final List<Allergy> listAllergy;
  final List<MedicalConditions> listConditions;

  UserFull(
      {required this.userDetail,
      required this.userMeasurement,
      required this.listAllergy,
      required this.listConditions});
}
