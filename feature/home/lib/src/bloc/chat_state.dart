part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final Stream<MessageModel>? messageModels;

  const ChatState({
    required this.currentChat,
    required this.messageModels,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    Stream<MessageModel>? messageModels,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        messageModels: messageModels ?? this.messageModels,
      );
}
