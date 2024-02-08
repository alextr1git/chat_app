import 'package:domain/domain.dart';

class SetListeningStatusUseCase
    implements FutureUseCase<Map<String, bool>, NoParams> {
  final ChatRepository _chatRepository;

  SetListeningStatusUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<NoParams> execute(Map<String, bool> mapChatIDtoStatus) async {
    Iterable<String> chatIDs = mapChatIDtoStatus.keys;
    String? chatID = chatIDs.firstOrNull;
    bool? status = mapChatIDtoStatus[chatID];
    if (chatID != null && status != null) {
      await _chatRepository.setListeningStatus(chatID: chatID, status: status);
    }

    return const NoParams();
  }
}
