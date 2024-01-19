part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;

  const ChatState({
    required this.currentChat,
    required this.chatsOfUser,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    List<ChatModel>? chatsOfUser,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
      );
}
