import 'package:flutter/material.dart';

class ChatMemberMessage extends StatelessWidget {
  final String username;
  final String message;
  final FileImage? image;

  const ChatMemberMessage({
    super.key,
    required this.username,
    required this.message,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: image,
                child: const Text(
                  "",
                  style: TextStyle(fontSize: 48),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username ?? "No name",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
