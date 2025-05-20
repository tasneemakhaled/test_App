import 'dart:convert';

import 'package:auti_warrior_app/models/MotherModels/mother_model.dart';
import 'package:http/http.dart' as http;

import '../help/constants.dart';

class MotherService {
  Future<List<Mother>> getAllMothers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/mothers'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Mother.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load mothers: ${response.statusCode}');
    }
  }
}
