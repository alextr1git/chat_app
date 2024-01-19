part of 'message_bloc.dart';

@immutable
class MessageState {
  final StreamController<List<MessageModel>> messageModelsStreamController;
  final ChatModel? currentChat;

  const MessageState({
    required this.messageModelsStreamController,
    required this.currentChat,
  });

  MessageState copyWith({
    StreamController<List<MessageModel>>? messageModelsStreamController,
    ChatModel? currentChat,
  }) =>
      MessageState(
        messageModelsStreamController:
            messageModelsStreamController ?? this.messageModelsStreamController,
        currentChat: currentChat ?? this.currentChat,
      );
}
