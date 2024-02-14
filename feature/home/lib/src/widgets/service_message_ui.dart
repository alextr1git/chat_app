import 'package:flutter/material.dart';

class ServiceMessage extends StatelessWidget {
  final String message;
  const ServiceMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
