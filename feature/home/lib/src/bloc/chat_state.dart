part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;
  final List<ChatMemberModel>? membersOfChat;

  const ChatState({
    required this.currentChat,
    required this.chatsOfUser,
    this.membersOfChat,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    List<ChatModel>? chatsOfUser,
    List<ChatMemberModel>? membersOfChat,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
        membersOfChat: membersOfChat ?? this.membersOfChat,
      );
}
