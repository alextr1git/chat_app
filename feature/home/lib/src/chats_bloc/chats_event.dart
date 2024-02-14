part of 'chats_bloc.dart';

@immutable
abstract class ChatsEvent {}

class InitChatsEvent extends ChatsEvent {}

class GetChatsForUser extends ChatsEvent {}

class GetLastMessagesOfChatEvent extends ChatsEvent {
  final List<ChatModel> listOfChatModels;

  GetLastMessagesOfChatEvent({required this.listOfChatModels});
}

class SearchInChatsEvent extends ChatsEvent {
  final String query;

  SearchInChatsEvent({required this.query});
}

class ChatsHasBeenUpdatedEvent extends ChatsEvent {
  final List<ChatModel> updatedListOfChatModels;

  ChatsHasBeenUpdatedEvent({
    required this.updatedListOfChatModels,
  });
}

class NavigateToPersonalChatViewEvent extends ChatsEvent {
  final ChatModel selectedChat;

  NavigateToPersonalChatViewEvent({required this.selectedChat});
}

class NavigateToAddChatViewEvent extends ChatsEvent {}

class DisposeChatBlocEvent extends ChatsEvent {}
