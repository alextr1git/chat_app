import 'package:data/entities/chats/message_entity.dart';

abstract class RealTimeDatabaseProvider {
  Future<void> postNewMessage(
    MessageEntity messageEntity,
  );
}
