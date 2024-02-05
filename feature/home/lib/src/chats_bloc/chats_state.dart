part of 'chats_bloc.dart';

@immutable
abstract class ChatsState {}

class ChatsDataFetchingState extends ChatsState {}

class ChatsAllDataFetchedState extends ChatsState {
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

class ChatsErrorState extends ChatsState {
  final String? error;

  ChatsErrorState({required this.error});
}
