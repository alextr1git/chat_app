part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatsDataFetchingState extends ChatState {}

class ChatsAllDataFetchedState extends ChatState {
  final List<ChatModel> listOfAllChatsOfUser;
  final List<ChatModel> listOfFilteredChatsOfUser;
  final Map<String, MessageModel> lastMessagesForChats;

  ChatsAllDataFetchedState({
    required this.listOfAllChatsOfUser,
    required this.listOfFilteredChatsOfUser,
    required this.lastMessagesForChats,
  });

  ChatsAllDataFetchedState copyWith({
    List<ChatModel>? listOfAllChatsOfUser,
    List<ChatModel>? listOfFilteredChatsOfUser,
    Map<String, MessageModel>? lastMessagesForChats,
  }) =>
      ChatsAllDataFetchedState(
        listOfAllChatsOfUser: listOfAllChatsOfUser ?? this.listOfAllChatsOfUser,
        listOfFilteredChatsOfUser:
            listOfFilteredChatsOfUser ?? this.listOfFilteredChatsOfUser,
        lastMessagesForChats: lastMessagesForChats ?? this.lastMessagesForChats,
      );
}

class ChatsSingleChatDataFetchedState extends ChatState {
  final ChatModel currentChat;
  final List<ChatMemberModel> activeMembersOfChat;
  final List<ChatMemberModel> allMembersOfChat;

  ChatsSingleChatDataFetchedState({
    required this.currentChat,
    required this.activeMembersOfChat,
    required this.allMembersOfChat,
  });
}

class ChatsErrorState extends ChatState {
  final String? error;

  ChatsErrorState({required this.error});
}
