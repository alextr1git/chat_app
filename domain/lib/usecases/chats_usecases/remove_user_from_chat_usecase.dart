import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class RemoveUserFromChatUseCase
    implements FutureUseCase<Map<String, String>, NoParams> {
  final ChatRepository _chatRepository;

  RemoveUserFromChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<NoParams> execute(Map<String, String> removeUserFromChatMap) async {
    final String? userID = removeUserFromChatMap["userID"];
    final String? chatID = removeUserFromChatMap["chatID"];
    if (userID != null && chatID != null) {
      _chatRepository.removeUserFromChat(userID: userID, chatID: chatID);
    }
    return NoParams();
  }
}
