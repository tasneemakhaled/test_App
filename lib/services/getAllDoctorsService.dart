import 'dart:developer';

import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:dio/dio.dart';

import '../models/doctorModels/AllDoctorsModel.dart';

class Getalldoctorsservice {
  Dio dio = Dio();
  final String baseUrl = "http://192.168.1.13:8081";
  Future<List<AllDoctorsModel>> getAllDoctors() async {
    try {
      String? token = await StorageService().getToken(); // احصلي على التوكن

      Response response = await dio.get(
        '$baseUrl/api/doctors',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        List<AllDoctorsModel> doctors = (response.data as List)
            .map((doctor) => AllDoctorsModel.fromJson(doctor))
            .toList();
        return doctors;
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }
}
