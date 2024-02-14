import 'package:domain/domain.dart';

class GetChatsForUserUseCase
    implements StreamUseCase<NoParams, List<ChatModel>> {
  final ChatRepository _chatRepository;

  GetChatsForUserUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Stream<List<ChatModel>> execute(NoParams noParams) {
    return _chatRepository.getChatsForUser();
  }
}
