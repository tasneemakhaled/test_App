import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // height: 50,
        // width: 130,
        margin: EdgeInsets.all(8),
        // alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            )),
        child: Text(
          'how are you?',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
