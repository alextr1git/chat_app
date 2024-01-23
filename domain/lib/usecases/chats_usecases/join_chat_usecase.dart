import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class JoinChatUseCase implements FutureUseCase<String, ChatModel?> {
  final ChatRepository _chatRepository;

  JoinChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<ChatModel?> execute(String chatId) async {
    return _chatRepository.joinChat(chatId);
  }
}
