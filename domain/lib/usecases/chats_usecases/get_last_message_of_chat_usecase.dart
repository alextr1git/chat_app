import 'package:domain/domain.dart';

class GetLastsMessagesOfChatUseCase
    implements FutureUseCase<List<ChatModel>, Map<String, MessageModel>> {
  final ChatRepository _chatRepository;

  GetLastsMessagesOfChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<Map<String, MessageModel>> execute(
      List<ChatModel> listOfChatModels) async {
    return _chatRepository.getModelsOfLastMessagesOfChat(listOfChatModels);
  }
}
