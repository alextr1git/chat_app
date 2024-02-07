class ChatMemberEntity {
  final String uid;
  final String username;
  final String? image;
  final bool isMember;

  ChatMemberEntity({
    required this.uid,
    required this.isMember,
    required this.username,
    this.image,
  });

  ChatMemberEntity copyWith({
    String? uid,
    String? username,
    String? image,
    bool? isMember,
  }) =>
      ChatMemberEntity(
        uid: uid ?? this.uid,
        isMember: isMember ?? this.isMember,
        username: username ?? this.username,
        image: image ?? this.image,
      );
}
