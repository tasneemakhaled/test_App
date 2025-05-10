// lib/services/doctor_service.dart
import 'dart:convert';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:http/http.dart' as http;
import '../models/doctorModels/UpdateProfileModel.dart';

class DoctorService {
  // final String baseUrl = "http://192.168.1.10:8081";

  // Function to update doctor profile
  Future<http.Response> completeProfile(Doctor doctor) async {
    try {
      print("\n===== SENDING REQUEST TO API =====");
      print("📍 URL: $baseUrl/api/doctors/completeProfile");
      print("📦 Data: ${jsonEncode(doctor.toJson())}");
      print("=================================\n");

      final response = await http.post(
        Uri.parse('$baseUrl/api/doctors/complete-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
          'User-Agent': 'FlutterApp',
        },
        body: jsonEncode(doctor.toJson()),
      );

      // طباعة تفاصيل الاستجابة للتشخيص
      print("\n===== API RESPONSE DETAILS =====");
      print("📊 Status Code: ${response.statusCode}");
      print("📄 Response Body: ${response.body}");
      print("=================================\n");

      return response;
    } catch (e) {
      print("\n❌ API ERROR =====");
      print("🔍 Error Type: ${e.runtimeType}");
      print("📝 Error Details: $e");
      print("=================================\n");

      // إعادة توجيه الاستثناء ليتم التعامل معه في الدالة الأصلية
      throw e;
    }
  }

  // Function to get doctor profile
  Future<Doctor?> getDoctorProfile(int doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/doctors/$doctorId'),
        headers: {
          // You can add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      // طباعة تفاصيل الاستجابة للتشخيص
      print("\n===== GET PROFILE RESPONSE =====");
      print("📊 Status Code: ${response.statusCode}");
      print("📄 Response Body: ${response.body}");
      print("=================================\n");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Doctor.fromJson(data);
      } else {
        print('Failed to fetch profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
