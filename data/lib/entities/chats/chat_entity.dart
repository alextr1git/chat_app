import 'package:flutter/material.dart';

class ChatEntity {
  final String id;
  final String title;
  final String lastMessageId;
  final num timestamp;
  final int messageCount;
  final String creatorId;
  final int color;

  ChatEntity({
    required this.id,
    required this.title,
    required this.lastMessageId,
    required this.timestamp,
    required this.messageCount,
    required this.creatorId,
    required this.color,
  });

  ChatEntity copyWith({
    String? id,
    String? title,
    String? lastMessageId,
    num? timestamp,
    int? messageCount,
    String? creatorId,
    int? color,
  }) =>
      ChatEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        timestamp: timestamp ?? this.timestamp,
        messageCount: messageCount ?? this.messageCount,
        creatorId: creatorId ?? this.creatorId,
        color: color ?? this.color,
      );

  factory ChatEntity.fromJson(Map<Object?, Object?> json, String chatId) =>
      ChatEntity(
        id: chatId ?? "",
        title: json['title'] as String ?? "",
        lastMessageId: json['last-message-id'] as String ?? "",
        timestamp: json['timestamp'] as num ?? 0,
        messageCount: json['message-count'] as int ?? 0,
        creatorId: json['creator-id'] as String ?? "",
        color: json['color'] as int ?? 0,
      );
}
