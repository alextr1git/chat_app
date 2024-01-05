class UserEntity {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String userName;

  UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.userName,
  });
  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['uid'] ?? "",
        email: json['email'] ?? "",
        isEmailVerified: json['emailVerified'] ?? false,
        userName: json['displayName'] ?? "",
      );
}
/*

Map<String, dynamic> toJson() => {
"street": street,
"suite": suite,
"city": city,
"zipcode": zipcode,
"geo": geo,
};*/
