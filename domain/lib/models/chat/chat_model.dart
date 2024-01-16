import 'package:flutter/material.dart';

@immutable
class ChatModel {
  final String id;
  final String title;
  final String lastMessage;
  final num timestamp;
  final int messageCount;

  const ChatModel({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    required this.messageCount,
  });

  ChatModel copyWith({
    String? id,
    String? title,
    String? lastMessage,
    num? timestamp,
    int? messageCount,
  }) =>
      ChatModel(
        id: id ?? this.id,
        title: title ?? this.title,
        lastMessage: lastMessage ?? this.lastMessage,
        timestamp: timestamp ?? this.timestamp,
        messageCount: messageCount ?? this.messageCount,
      );
}
