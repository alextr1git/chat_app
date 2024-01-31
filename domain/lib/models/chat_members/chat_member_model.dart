import 'package:flutter/material.dart';

class ChatMemberModel {
  final String uid;
  final bool isMember;
  final String username;
  final String? image;

  ChatMemberModel({
    required this.uid,
    required this.isMember,
    required this.username,
    this.image,
  });

  ChatMemberModel copyWith({
    String? uid,
    String? username,
    String? image,
    bool? isMember,
  }) =>
      ChatMemberModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        image: image ?? this.image,
        isMember: isMember ?? this.isMember,
      );
}
