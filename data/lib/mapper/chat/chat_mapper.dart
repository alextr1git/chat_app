import 'package:data/entities/chats/chat_entity.dart';
import 'package:domain/domain.dart';

abstract class ChatMapper {
  static ChatEntity toEntity(ChatModel model) {
    return ChatEntity(
      id: model.id,
      title: model.title,
      lastMessageId: model.lastMessageId,
      timestamp: model.timestamp,
      messageCount: model.messageCount,
    );
  }

  static ChatModel toModel(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      title: entity.title,
      lastMessageId: entity.lastMessageId,
      timestamp: entity.timestamp,
      messageCount: entity.messageCount,
    );
  }
}
