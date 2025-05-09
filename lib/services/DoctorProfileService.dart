// lib/services/doctor_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctorModels/UpdateProfileModel.dart';

class DoctorService {
  final String baseUrl = "http://192.168.1.13:8081";
  // Function to update doctor profile
  Future<bool> completeProfile(Doctor doctor) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/doctors/completeProfile'),
        headers: {
          'Content-Type': 'application/json',
          // You can add authentication token here if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(doctor.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
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
