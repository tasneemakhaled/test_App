import 'dart:convert';
import 'package:auti_warrior_app/help/constants.dart'; // Make sure baseUrl is defined here
import 'package:auti_warrior_app/models/ChatModels/message_model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  // داخل MessageService.dart

  Future<List<MessageModel>> fetchMessages(
      String currentUserEmail, String otherUserEmail) async {
    List<MessageModel> allMessages = [];

    try {
      print(
          'Fetching ALL messages between $currentUserEmail and $otherUserEmail (single API call)');

      // استدعِ الـ API مرة واحدة فقط. لا يهم الترتيب إذا كان الـ API يتعامل معها بشكل تبادلي.
      // يمكنك استخدام أي ترتيب للإيميلات هنا.
      final uri =
          Uri.parse('$baseUrl/api/messages/$currentUserEmail/$otherUserEmail');
      print('Attempting to GET: $uri');
      final response = await http.get(uri);
      print('Response (Single Call) - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            List<dynamic> data = jsonDecode(response.body);
            allMessages.addAll(data
                .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
                .toList());
            print('Fetched ${data.length} messages in a single call.');
          } catch (e) {
            print(
                "Error decoding JSON from single response: $e. Body: ${response.body}");
          }
        } else {
          print("Single response body is empty, though status is 200.");
        }
      } else {
        print(
            "Failed to load messages in single call. Status: ${response.statusCode}, Body: ${response.body}");
        throw Exception(
            "Failed to load messages. Status: ${response.statusCode}");
      }

      // لا نحتاج إلى استدعاء ثانٍ إذا كان الاستدعاء الأول يرجع كل شيء

      // افرز الرسائل التي تم جلبها
      allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      print(
          "Fetched a total of ${allMessages.length} messages (from single call). Sorted chronologically.");
      return allMessages;
    } catch (e) {
      print("Error in fetchMessages service: $e");
      throw Exception("Failed to load messages due to an error: $e");
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      print('Sending message: ${message.toJson()}');
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/messages'), // Endpoint for sending a new message
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(message.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // 201 Created is also a success
        print(
            "Failed to send message. Status: ${response.statusCode}, Body: ${response.body}");
        throw Exception(
            "Failed to send message: Server responded with ${response.statusCode}");
      }
      print("Message sent successfully. Response: ${response.body}");
    } catch (e) {
      print("Error sending message: $e");
      throw Exception("Failed to send message due to an error: $e");
    }
  }
}
