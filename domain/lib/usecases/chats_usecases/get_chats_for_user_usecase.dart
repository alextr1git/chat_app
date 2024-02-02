import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetChatsForUserUseCase
    implements StreamUseCase<NoParams, List<ChatModel>> {
  final ChatRepository _chatRepository;

  GetChatsForUserUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Stream<List<ChatModel>> execute(NoParams) {
    return _chatRepository.getChatsForUser();
  }
}
