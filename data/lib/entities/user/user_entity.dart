import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String userName;
  final String photoURL;

  UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.userName,
    required this.photoURL,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['uid'] ?? "",
        email: json['email'] ?? "",
        isEmailVerified: json['emailVerified'] ?? false,
        userName: json['userName'] ?? false,
        photoURL: json['photoURL'] ?? false,
      );

  factory UserEntity.fromFirebase(User user) => UserEntity(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        userName: user.displayName ?? '',
        photoURL: user.photoURL ?? '',
      );

  static UserEntity get empty {
    return UserEntity(
      email: '',
      id: '',
      isEmailVerified: false,
      userName: '',
      photoURL: '',
    );
  }
}
