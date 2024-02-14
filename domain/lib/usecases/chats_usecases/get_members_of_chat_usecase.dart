import 'package:domain/domain.dart';

class GetMembersOfChatUseCase
    implements FutureUseCase<String, List<ChatMemberModel>> {
  final ChatRepository _chatRepository;

  GetMembersOfChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<List<ChatMemberModel>> execute(String chatID) async {
    List<ChatMemberModel> listOfChatMemberModels =
        await _chatRepository.getMembersOfChat(chatID);
    return listOfChatMemberModels;
  }
}
