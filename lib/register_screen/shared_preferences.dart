// ✅ shared_preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static Future<void> setUserPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', pin);
  }

  static Future<String?> getUserPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_pin');
  }

  static Future<void> setRegistrationStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_registered', status);
  }

  static Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_registered') ?? false;
  }

  static Future<void> setEncryptedFilePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('encrypted_path', path);
  }

  static Future<String?> getEncryptedFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('encrypted_path');
  }

  static Future<void> setJsonHash(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('json_hash', hash);
  }

  static Future<String?> getJsonHash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('json_hash');
  }

  static Future<void> setKycHash(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kyc_hash', hash);
  }

  static Future<String?> getKycHash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('kyc_hash');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
