import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String photoURL;

  UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.photoURL,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['uid'] ?? "",
        email: json['email'] ?? "",
        isEmailVerified: json['emailVerified'] ?? false,
        photoURL: json['photoURL'] ?? false,
      );

  factory UserEntity.fromFirebase(User user) => UserEntity(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        photoURL: user.photoURL ?? '',
      );

  static UserEntity get empty {
    return UserEntity(
      email: '',
      id: '',
      isEmailVerified: false,
      photoURL: '',
    );
  }
}
