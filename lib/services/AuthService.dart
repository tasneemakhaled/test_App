import 'dart:convert';
import 'package:auti_warrior_app/models/AuthModels/LoginModel.dart';
import 'package:auti_warrior_app/models/AuthModels/RegisterModel.dart';
import 'package:http/http.dart' as http;
import '../models/AuthModels/AuthResponse.dart';

class AuthService {
  final String baseUrl = "http://192.168.1.10:8081";

  /// 🟢 Register a new user
  Future<AuthResponse> register(RegisterModel registerModel) async {
    final url = Uri.parse("$baseUrl/api/auth/register");
    print("🔹 Sending Register Request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(registerModel.toJson()),
      );

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        // تحقق مما إذا كانت الاستجابة عبارة عن رسالة نجاح نصية بسيطة
        if (response.body.contains("New user registered successfully")) {
          // إنشاء استجابة مخصصة بناءً على بيانات التسجيل
          return AuthResponse(
            token:
                "temp_token", // ستحتاج إلى تنفيذ تسجيل الدخول للحصول على الرمز الفعلي
            role: registerModel.role,
            firstName: registerModel.firstName,
            lastName: registerModel.lastName,
          );
        } else {
          // محاولة تحليل الاستجابة كـ JSON
          try {
            final responseData = _parseResponse(response.body);
            return AuthResponse.fromJson(responseData);
          } catch (e) {
            print(
                "⚠️ Error parsing JSON: $e, falling back to default response");
            return AuthResponse(
              token: "temp_token",
              role: registerModel.role,
              firstName: registerModel.firstName,
              lastName: registerModel.lastName,
            );
          }
        }
      } else {
        throw Exception("❌ Registration Failed: ${response.body}");
      }
    } catch (error) {
      throw Exception("❌ Registration Error: $error");
    }
  }

  /// 🟢 User login
  Future<AuthResponse> login(LoginModel loginModel) async {
    final url = Uri.parse("$baseUrl/api/auth/login");
    print("🔹 Sending Login Request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginModel.toJson()),
      );

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = _parseResponse(response.body);
        // Check if role is missing in response and extract from token if needed
        if (responseData.containsKey("token") &&
            (!responseData.containsKey("role") ||
                responseData["role"].isEmpty)) {
          final role = _extractRoleFromToken(responseData["token"]);
          responseData["role"] = role;
        }

        return AuthResponse.fromJson(responseData);
      } else {
        throw Exception("❌ Login Failed: ${response.body}");
      }
    } catch (error) {
      throw Exception("❌ Login Error: $error");
    }
  }

  /// Extract role from JWT token - FIXED VERSION
  String _extractRoleFromToken(String token) {
    try {
      // Split the token to get the payload part
      final parts = token.split('.');
      if (parts.length != 3) {
        print("⚠️ Invalid token format");
        return "";
      }

      // Decode the payload
      String payload = parts[1];
      // Add padding if needed
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      // Replace characters that are not URL safe
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');

      // Decode base64
      final decodedPayload = utf8.decode(base64Url.decode(payload));
      final payloadMap = json.decode(decodedPayload);

      // Extract role
      String roleValue = payloadMap["role"] ?? "";
      print("🔹 Raw role from token: $roleValue");

      // Check if the role is a string representation of a map like "{role=DOCTOR, provider=local, providerId=null}"
      if (roleValue.startsWith("{") && roleValue.contains("role=")) {
        // Extract just the role value from the string
        final startIndex =
            roleValue.indexOf("role=") + 5; // +5 to move past "role="
        final endIndex = roleValue.indexOf(",", startIndex);
        if (endIndex > startIndex) {
          roleValue = roleValue.substring(startIndex, endIndex).trim();
        } else {
          // If there's no comma (single attribute)
          roleValue = roleValue
              .substring(startIndex, roleValue.indexOf("}", startIndex))
              .trim();
        }
      }

      print("🔹 Extracted role value: $roleValue");
      return roleValue;
    } catch (e) {
      print("⚠️ Error extracting role from token: $e");
      return "";
    }
  }

  /// 🟢 Logout using token
  Future<bool> logout(String token) async {
    final url = Uri.parse("$baseUrl/api/auth/logout");
    print("🔹 Sending Logout Request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (error) {
      print("❌ Logout Error: $error");
      return false;
    }
  }

  /// 🟢 Function to process server response and verify it's JSON
  Map<String, dynamic> _parseResponse(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (e) {
      print("⚠️ Response is not JSON, handling as raw string.");
      return {"token": responseBody}; // Handle token as plain text
    }
  }
}
