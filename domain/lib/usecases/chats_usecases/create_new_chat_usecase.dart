import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class CreateNewChatUseCase implements FutureUseCase<ChatModel, ChatModel?> {
  final ChatRepository _chatRepository;

  CreateNewChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<ChatModel?> execute(ChatModel chatModel) async {
    return _chatRepository.createNewChat(chatModel);
  }
}
