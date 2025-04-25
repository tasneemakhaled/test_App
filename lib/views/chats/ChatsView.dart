import 'package:auti_warrior_app/widgets/Chat%20Widgets/chat_bubble.dart';
import 'package:auti_warrior_app/widgets/Chat%20Widgets/reverse_chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  ChatsView({super.key});
  String? message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Column(
                children: [ChatBubble(), ReverseChatBubble()],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                message = value;
              },
              decoration: InputDecoration(
                  hintText: 'Message',
                  suffixIcon: Icon(
                    Icons.send,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
        ],
      ),
    );
  }
}
