import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Keys for SharedPreferences
  static const String tokenKey = 'auth_token';
  static const String roleKey = 'user_role';
  static const String emailKey = 'user_email';
  static const String firstNameKey = 'user_first_name';
  static const String lastNameKey = 'user_last_name';
  static const String doctorIdKey = 'doctor_id';
  static const String logoutTimeKey = 'last_logout_time';

  // Save Methods
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(roleKey, role);
  }

  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  Future<void> saveFirstName(String firstName) async {
    print("💾 Saving firstName: '$firstName'");
    if (firstName.isEmpty) {
      print("⚠️ Warning: Saving empty firstName");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(firstNameKey, firstName);
    print(
        "✅ Verification - firstName saved as: '${prefs.getString(firstNameKey)}'");
  }

  Future<void> saveLastName(String lastName) async {
    print("💾 Saving lastName: '$lastName'");
    if (lastName.isEmpty) {
      print("⚠️ Warning: Saving empty lastName");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastNameKey, lastName);
    print(
        "✅ Verification - lastName saved as: '${prefs.getString(lastNameKey)}'");
  }

  Future<void> saveDoctorId(String doctorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(doctorIdKey, doctorId);
  }

  Future<void> saveLastLogoutTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(logoutTimeKey, time.toIso8601String());
    print("📦 Last logout time saved: $time");
  }

  // Get Methods
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<String> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString(firstNameKey) ?? "";
    print("📖 Retrieved firstName: '$firstName'");
    return firstName;
  }

  Future<String> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    final lastName = prefs.getString(lastNameKey) ?? "";
    print("📖 Retrieved lastName: '$lastName'");
    return lastName;
  }

  Future<String?> getDoctorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(doctorIdKey);
  }

  Future<DateTime?> getLastLogoutTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(logoutTimeKey);
    if (timeStr != null) {
      final parsed = DateTime.tryParse(timeStr);
      print("🕒 Retrieved logout time: $parsed");
      return parsed;
    }
    return null;
  }

  // Helper method to get full name
  Future<String> getFullName() async {
    final firstName = await getFirstName();
    final lastName = await getLastName();
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? "Doctor" : fullName;
  }

  // 🔹 Clear token only
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    print("🧹 Cleared token");
  }

  // 🔹 Clear role only
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(roleKey);
    print("🧹 Cleared role");
  }

  // 🔹 Clear all session-related data (except logout time)
  Future<void> clearAllSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await saveLastLogoutTime(DateTime.now());
    await prefs.remove(tokenKey);
    await prefs.remove(roleKey);
    await prefs.remove(emailKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(lastNameKey);
    await prefs.remove(doctorIdKey);
    print("🧹 Cleared all session data");
  }

  // 🔹 Clear everything including logout time
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🧨 Cleared all data");
  }
}
