part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;
  final Stream<MessageModel>? messageModelsStream;

  const ChatState({
    required this.currentChat,
    required this.messageModelsStream,
    required this.chatsOfUser,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    Stream<MessageModel>? messageModelsStream,
    List<ChatModel>? chatsOfUser,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        messageModelsStream: messageModelsStream ?? this.messageModelsStream,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
      );
}
