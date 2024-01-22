import 'package:data/entities/chat_members/chat_member_entity.dart';
import 'package:domain/domain.dart';

abstract class ChatMemberMapper {
  static ChatMemberEntity toEntity(ChatMemberModel model) {
    return ChatMemberEntity(
      uid: model.uid,
      username: model.username,
      image: model.image,
    );
  }

  static ChatMemberModel toModel(ChatMemberEntity entity) {
    return ChatMemberModel(
      uid: entity.uid,
      username: entity.username,
      image: entity.image,
    );
  }
}
