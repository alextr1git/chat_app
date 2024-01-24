import 'dart:async';

import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetMessagesForChatUseCase
    implements StreamUseCase<ChatModel, List<MessageModel>> {
  final ChatRepository _chatRepository;

  GetMessagesForChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Stream<List<MessageModel>> execute(ChatModel chatModel) {
    return _chatRepository.getMessagesForChat(chatModel);
  }
}
