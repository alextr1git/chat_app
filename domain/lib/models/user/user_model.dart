import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String id;
  final bool isEmailVerified;
  final String email;
  final String userName;
  final String photoURL;

  const UserModel({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.userName,
    required this.photoURL,
  });

  UserModel copyWith({
    String? id,
    String? email,
    bool? isEmailVerified,
    String? userName,
    String? photoURL,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        userName: userName ?? this.userName,
        photoURL: photoURL ?? this.photoURL,
      );

  static UserModel get empty {
    return const UserModel(
      email: '',
      id: '',
      isEmailVerified: false,
      userName: '',
      photoURL: '',
    );
  }
}
