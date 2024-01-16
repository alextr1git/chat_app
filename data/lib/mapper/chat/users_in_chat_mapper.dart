import 'package:data/entities/chats/users_in_chat_entity.dart';
import 'package:domain/domain.dart';

abstract class UsersInChatMapper {
  static UsersInChatEntity toEntity(UsersInChatModel model) {
    return UsersInChatEntity(
      chatId: model.chatId,
      users: model.users,
    );
  }

  static UsersInChatModel toModel(UsersInChatEntity entity) {
    return UsersInChatModel(
      chatId: entity.chatId,
      users: entity.users,
    );
  }
}
