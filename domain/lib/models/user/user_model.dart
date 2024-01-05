import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String id;
  final bool isEmailVerified;
  final String email;
  final String userName;

  const UserModel({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.userName,
  });

  UserModel copyWith({
    String? id,
    String? email,
    bool? isEmailVerified,
    String? userName,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        userName: userName ?? this.userName,
      );
}

/* factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        userName: '',
      );*/
