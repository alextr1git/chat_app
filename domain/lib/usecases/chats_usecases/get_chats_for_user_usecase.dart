import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetChatsForUserUseCase
    implements FutureUseCase<NoParams, List<ChatModel>> {
  final ChatRepository _chatRepository;

  GetChatsForUserUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<List<ChatModel>> execute(NoParams) async {
    return _chatRepository.getChatsForUser();
  }
}
