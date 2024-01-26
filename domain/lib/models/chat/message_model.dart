import 'package:flutter/material.dart';

@immutable
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final int timeStamp;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.timeStamp,
  });

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? message,
    int? timeStamp,
  }) =>
      MessageModel(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        timeStamp: timeStamp ?? this.timeStamp,
        message: message ?? this.message,
      );
}
