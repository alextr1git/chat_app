import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<void> postMessage(MessageModel messageModel);
}
