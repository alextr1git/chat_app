import 'package:flutter/material.dart';

class ChatMemberModel {
  final String uid;
  final String? username;
  final String? image;

  ChatMemberModel({
    required this.uid,
    required this.username,
    required this.image,
  });

  ChatMemberModel copyWith({
    String? uid,
    String? username,
    String? image,
  }) =>
      ChatMemberModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        image: image ?? this.image,
      );
}
