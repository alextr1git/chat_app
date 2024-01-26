import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetLastMessageOfChatUseCase
    implements FutureUseCase<ChatModel, MessageModel?> {
  final ChatRepository _chatRepository;

  GetLastMessageOfChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<MessageModel?> execute(ChatModel chatModel) async {
    return _chatRepository.getModelOfLastMessageOfChat(chatModel);
  }
}
