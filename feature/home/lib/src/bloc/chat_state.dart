part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ChatModel? currentChat;
  final List<ChatModel>? chatsOfUser;
  final List<ChatMemberModel>? activeMembersOfChat;
  final List<ChatMemberModel>? allMembersOfChat;
  final MessageModel? lastMessageModel;
  final String? error;

  const ChatState({
    required this.currentChat,
    required this.chatsOfUser,
    required this.activeMembersOfChat,
    required this.allMembersOfChat,
    required this.error,
    required this.lastMessageModel,
  });

  ChatState copyWith({
    ChatModel? currentChat,
    List<ChatModel>? chatsOfUser,
    List<ChatMemberModel>? activeMembersOfChat,
    List<ChatMemberModel>? allMembersOfChat,
    String? error,
    MessageModel? lastMessageModel,
  }) =>
      ChatState(
        currentChat: currentChat ?? this.currentChat,
        chatsOfUser: chatsOfUser ?? this.chatsOfUser,
        activeMembersOfChat: activeMembersOfChat ?? this.activeMembersOfChat,
        allMembersOfChat: allMembersOfChat ?? this.allMembersOfChat,
        error: error ?? this.error,
        lastMessageModel: lastMessageModel ?? this.lastMessageModel,
      );
}
