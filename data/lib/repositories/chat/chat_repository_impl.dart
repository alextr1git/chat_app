import 'package:data/entities/chats/message_entity.dart';
import 'package:data/mapper/chat/message_mapper.dart';
import 'package:data/providers/realtime_database/rt_database_provider.dart';
import 'package:domain/domain.dart';
import 'package:domain/repositories/repositories.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RealTimeDatabaseProvider _databaseProvider;

  ChatRepositoryImpl({required databaseProvider})
      : _databaseProvider = databaseProvider;
  @override
  Future<void> postMessage(MessageModel messageModel) async {
    MessageEntity messageEntity = MessageMapper.toEntity(messageModel);
    await _databaseProvider.postNewMessage(messageEntity);
  }
}
