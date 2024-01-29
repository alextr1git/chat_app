part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class NavigateToPersonalChatViewEvent extends ChatEvent {
  final ChatModel selectedChat;

  NavigateToPersonalChatViewEvent({required this.selectedChat});
}

class NavigateToAddChatViewEvent extends ChatEvent {}

class CreateNewChatEvent extends ChatEvent {
  final ChatModel chatModel;

  CreateNewChatEvent({required this.chatModel});
}

class JoinChatEvent extends ChatEvent {
  final String chatID;

  JoinChatEvent({required this.chatID});
}

class GetChatsForUser extends ChatEvent {}

class PopChatRouteEvent extends ChatEvent {}

class NavigateToChatsViewEvent extends ChatEvent {}

class GetMembersOfChatEvent extends ChatEvent {
  final ChatModel chatModel;

  GetMembersOfChatEvent({required this.chatModel});
}

class GetLastMessagesOfChatEvent extends ChatEvent {
  final List<ChatModel> listOfChatModels;

  GetLastMessagesOfChatEvent({required this.listOfChatModels});
}

class RemoveUserFromChatEvent extends ChatEvent {
  final String userID;
  final ChatModel chat;

  RemoveUserFromChatEvent({
    required this.userID,
    required this.chat,
  });
}

class DisposeChatBlocEvent extends ChatEvent {}
