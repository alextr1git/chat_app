import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String email;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['uid'] ?? "",
        email: json['email'] ?? "",
        isEmailVerified: json['emailVerified'] ?? false,
      );

  factory UserEntity.fromFirebase(User user) => UserEntity(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

  static UserEntity get empty {
    return UserEntity(
      email: '',
      id: '',
      isEmailVerified: false,
    );
  }
}

/*

Map<String, dynamic> toJson() => {
"street": street,
"suite": suite,
"city": city,
"zipcode": zipcode,
"geo": geo,
};*/
