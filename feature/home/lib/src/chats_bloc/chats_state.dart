part of 'chats_bloc.dart';

@immutable
abstract class ChatsState {}

class ChatsDataFetchingState extends ChatsState {
  final StreamSubscription<List<ChatModel>>? streamSubscription;

  ChatsDataFetchingState({this.streamSubscription});
}

class ChatsAllDataFetchedState extends ChatsState {
  final List<ChatModel> listOfAllChatsOfUser;
  final List<ChatModel> listOfFilteredChatsOfUser;
  final Map<String, MessageModel> lastMessagesForChats;
  final StreamSubscription<List<ChatModel>> streamSubscription;

  ChatsAllDataFetchedState({
    required this.listOfAllChatsOfUser,
    required this.listOfFilteredChatsOfUser,
    required this.lastMessagesForChats,
    required this.streamSubscription,
  });

  ChatsAllDataFetchedState copyWith({
    List<ChatModel>? listOfAllChatsOfUser,
    List<ChatModel>? listOfFilteredChatsOfUser,
    Map<String, MessageModel>? lastMessagesForChats,
    StreamSubscription<List<ChatModel>>? streamSubscription,
  }) =>
      ChatsAllDataFetchedState(
        listOfAllChatsOfUser: listOfAllChatsOfUser ?? this.listOfAllChatsOfUser,
        listOfFilteredChatsOfUser:
            listOfFilteredChatsOfUser ?? this.listOfFilteredChatsOfUser,
        lastMessagesForChats: lastMessagesForChats ?? this.lastMessagesForChats,
        streamSubscription: streamSubscription ?? this.streamSubscription,
      );
}

class ChatsErrorState extends ChatsState {
  final String? error;

  ChatsErrorState({required this.error});
}
