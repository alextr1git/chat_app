import 'package:flutter/material.dart';

@immutable
class ChatModel {
  final String id;
  final String title;
  final String lastMessageId;
  final num timestamp;
  final int messageCount;

  const ChatModel({
    required this.id,
    required this.title,
    required this.lastMessageId,
    required this.timestamp,
    required this.messageCount,
  });

  ChatModel copyWith({
    String? id,
    String? title,
    String? lastMessageId,
    num? timestamp,
    int? messageCount,
  }) =>
      ChatModel(
        id: id ?? this.id,
        title: title ?? this.title,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        timestamp: timestamp ?? this.timestamp,
        messageCount: messageCount ?? this.messageCount,
      );
}
