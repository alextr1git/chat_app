import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class CreateNewChatUseCase implements FutureUseCase<ChatModel, NoParams> {
  final ChatRepository _chatRepository;

  CreateNewChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<NoParams> execute(ChatModel chatModel) async {
    _chatRepository.createNewChat(chatModel);
    return NoParams();
  }
}
