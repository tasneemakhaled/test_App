import 'dart:convert';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  // final String baseUrl = "http://192.168.1.11:8081";

  Future<List<MessageModel>> fetchMessages(
      String senderEmail, String receiverEmail) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/messages/$senderEmail/$receiverEmail'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load messages");
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/messages'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.statusCode);
      throw Exception("Failed to send message");
    }
  }
}
