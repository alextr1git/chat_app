import 'package:flutter/material.dart';

@immutable
class ChatModel {
  final String id;
  final String title;
  final String lastMessageId;
  final int timestamp;
  final int messageCount;
  final String creatorId;
  final int color;

  const ChatModel({
    required this.id,
    required this.title,
    required this.lastMessageId,
    required this.timestamp,
    required this.messageCount,
    required this.creatorId,
    required this.color,
  });

  ChatModel copyWith({
    String? id,
    String? title,
    String? lastMessageId,
    int? timestamp,
    int? messageCount,
    String? creatorId,
    int? color,
  }) =>
      ChatModel(
        id: id ?? this.id,
        title: title ?? this.title,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        timestamp: timestamp ?? this.timestamp,
        messageCount: messageCount ?? this.messageCount,
        creatorId: creatorId ?? this.creatorId,
        color: color ?? this.color,
      );
}
