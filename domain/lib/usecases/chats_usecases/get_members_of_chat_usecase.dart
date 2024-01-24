import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetMembersOfChatUsecase
    implements FutureUseCase<String, List<ChatMemberModel>> {
  final ChatRepository _chatRepository;

  GetMembersOfChatUsecase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<List<ChatMemberModel>> execute(String chatID) async {
    List<ChatMemberModel> listOfChatMemberModels =
        await _chatRepository.getMembersOfChat(chatID);
    return listOfChatMemberModels;
  }
}
