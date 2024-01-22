import 'package:flutter/material.dart';

class ChatMemberEntity {
  final String uid;
  final String? username;
  final String? image;

  ChatMemberEntity({
    required this.uid,
    this.username,
    this.image,
  });

  ChatMemberEntity copyWith({
    String? uid,
    String? username,
    String? image,
  }) =>
      ChatMemberEntity(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        image: image ?? this.image,
      );
}
