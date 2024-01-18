import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class PostMessageUseCase implements FutureUseCase<MessageModel, NoParams> {
  final ChatRepository _chatRepository;

  PostMessageUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<NoParams> execute(MessageModel messageModel) async {
    _chatRepository.postMessage(messageModel);
    return NoParams();
  }
}
