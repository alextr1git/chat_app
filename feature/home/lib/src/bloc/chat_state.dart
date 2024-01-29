part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;
  final List<ChatMemberModel>? activeMembersOfChat;
  final List<ChatMemberModel>? allMembersOfChat;
  final Map<String, MessageModel> lastMessagesForChats;
  final String? error;

  const ChatState({
    required this.currentChat,
    required this.chatsOfUser,
    required this.activeMembersOfChat,
    required this.allMembersOfChat,
    required this.error,
    required this.lastMessagesForChats,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    List<ChatModel>? chatsOfUser,
    List<ChatMemberModel>? activeMembersOfChat,
    List<ChatMemberModel>? allMembersOfChat,
    String? error,
    Map<String, MessageModel>? lastMessagesForChats,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
        activeMembersOfChat: activeMembersOfChat ?? this.activeMembersOfChat,
        allMembersOfChat: allMembersOfChat ?? this.allMembersOfChat,
        error: error ?? this.error,
        lastMessagesForChats: lastMessagesForChats ?? this.lastMessagesForChats,
      );
}
