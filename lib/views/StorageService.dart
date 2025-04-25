import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';

  Future<void> saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, firstName);
  }

  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstNameKey);
  }

  Future<void> saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNameKey, lastName);
  }

  Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastNameKey);
  }
}
