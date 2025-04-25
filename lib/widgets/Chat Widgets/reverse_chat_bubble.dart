import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReverseChatBubble extends StatelessWidget {
  const ReverseChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            )),
        child: Text(
          'helloooo',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
