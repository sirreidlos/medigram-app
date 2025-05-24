import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _isPatientKey = 'isPatient';

  static Future<void> saveUserRole(bool isPatient) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPatientKey, isPatient);
  }

  static Future<bool> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPatientKey) ?? true; // default to true (patient)
  }
}
