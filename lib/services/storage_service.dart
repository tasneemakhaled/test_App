import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  /// 🔹 حفظ التوكن بعد تسجيل الدخول
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// 🔹 استرجاع التوكن عند الحاجة
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// 🔹 حذف التوكن عند تسجيل الخروج
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// 🔹 حفظ الدور بعد تسجيل الدخول
  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role',
        role.toUpperCase()); // تحويل إلى أحرف كبيرة للتأكد من التطابق
  }

  /// 🔹 استرجاع الدور عند الحاجة
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// 🔹 حذف الدور عند تسجيل الخروج
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }

  /// 🔹 حفظ اسم المستخدم
  Future<void> saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_firstName', firstName);
  }

  /// 🔹 استرجاع اسم المستخدم
  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_firstName');
  }

  /// 🔹 حفظ اسم عائلة المستخدم
  Future<void> saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_lastName', lastName);
  }

  /// 🔹 استرجاع اسم عائلة المستخدم
  Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_lastName');
  }

  /// 🔹 حفظ وقت آخر تسجيل خروج
  Future<void> saveLastLogoutTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_logout_time', time.toIso8601String());
  }

  /// 🔹 استرجاع وقت آخر تسجيل خروج
  Future<DateTime?> getLastLogoutTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString('last_logout_time');
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    return null;
  }

  /// 🔹 حذف جميع بيانات الجلسة
  Future<void> clearAllSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    // حفظ وقت تسجيل الخروج
    await saveLastLogoutTime(DateTime.now());
  }

  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
