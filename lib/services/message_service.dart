import 'dart:convert';
import 'package:auti_warrior_app/help/constants.dart';
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:auti_warrior_app/services/storage_service.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final StorageService _storageService = StorageService();
  Future<List<MessageModel>> fetchMessages(
      String senderEmail, String receiverEmail) async {
    try {
      final sentResponse = await http.get(
        Uri.parse('$baseUrl/api/messages/$senderEmail/$receiverEmail'),
      );

      final receivedResponse = await http.get(
        Uri.parse('$baseUrl/api/messages/$receiverEmail/$senderEmail'),
      );

      if (sentResponse.statusCode == 200 &&
          receivedResponse.statusCode == 200) {
        List sentData = jsonDecode(sentResponse.body);
        List receivedData = jsonDecode(receivedResponse.body);

        List allData = [...sentData, ...receivedData];
        allData.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

        return allData.map((e) => MessageModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load messages");
      }
    } catch (e) {
      print("Error fetching messages: $e");
      throw Exception("Failed to load messages: $e");
    }
  }

  Future<List<MessageModel>> fetchMessageHistory(String receiverEmail) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/history?receiverEmail=$receiverEmail'),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        List<MessageModel> messages =
            data.map((e) => MessageModel.fromJson(e)).toList();

        if (messages.isNotEmpty) {
          String senderEmail = messages.first.senderEmail;
          if (senderEmail.isNotEmpty) {
            await _storageService.saveSenderEmail(senderEmail);
            print("✅ Saved senderEmail from history: $senderEmail");
          } else {
            print("⚠️ senderEmail in the first message is empty");
          }
        } else {
          print("⚠️ No messages found in history");
        }

        return messages;
      } else {
        throw Exception("Failed to load message history");
      }
    } catch (e) {
      print("Error fetching message history: $e");
      throw Exception("Failed to load message history: $e");
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
