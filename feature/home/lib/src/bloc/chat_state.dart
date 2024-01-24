part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;
  final List<ChatMemberModel>? activeMembersOfChat;
  final List<ChatMemberModel>? allMembersOfChat;

  const ChatState({
    required this.currentChat,
    required this.chatsOfUser,
    required this.activeMembersOfChat,
    required this.allMembersOfChat,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    List<ChatModel>? chatsOfUser,
    List<ChatMemberModel>? activeMembersOfChat,
    List<ChatMemberModel>? allMembersOfChat,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
        activeMembersOfChat: activeMembersOfChat ?? this.activeMembersOfChat,
        allMembersOfChat: allMembersOfChat ?? this.allMembersOfChat,
      );
}
