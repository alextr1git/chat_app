import 'package:flutter/material.dart';

class ChatOwnerMessage extends StatelessWidget {
  final String message;
  final Color colorOfMessage;
  const ChatOwnerMessage({
    super.key,
    required this.message,
    required this.colorOfMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorOfMessage,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
