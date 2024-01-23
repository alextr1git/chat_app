import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class CreateNewChatUseCase implements FutureUseCase<String, ChatModel?> {
  final ChatRepository _chatRepository;

  CreateNewChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<ChatModel?> execute(String chatTitle) async {
    return _chatRepository.createNewChat(chatTitle);
  }
}
