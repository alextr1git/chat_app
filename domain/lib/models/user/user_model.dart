import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String id;
  final bool isEmailVerified;
  final String email;

  const UserModel({
    required this.id,
    required this.email,
    required this.isEmailVerified,
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
      );

  static UserModel get empty {
    return const UserModel(
      email: '',
      id: '',
      isEmailVerified: false,
    );
  }
}
