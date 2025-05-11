import 'dart:convert';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  // This should be defined in your constants.dart file
  // final String baseUrl = "http://your-backend-url";

  Future<List<MessageModel>> fetchMessages(
      String senderEmail, String receiverEmail) async {
    try {
      // Get messages sent by the sender to receiver
      final sentResponse = await http.get(
        Uri.parse('$baseUrl/api/messages/$senderEmail/$receiverEmail'),
      );

      // Get messages sent by the receiver to sender
      final receivedResponse = await http.get(
        Uri.parse('$baseUrl/api/messages/$receiverEmail/$senderEmail'),
      );

      if (sentResponse.statusCode == 200 &&
          receivedResponse.statusCode == 200) {
        List sentData = jsonDecode(sentResponse.body);
        List receivedData = jsonDecode(receivedResponse.body);

        // Combine both lists
        List allData = [...sentData, ...receivedData];

        // Sort messages by timestamp if your model has one
        // allData.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

        return allData.map((e) => MessageModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load messages");
      }
    } catch (e) {
      print("Error fetching messages: $e");
      throw Exception("Failed to load messages: $e");
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(message.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to send message: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
      throw Exception("Failed to send message: $e");
    }
  }
}
