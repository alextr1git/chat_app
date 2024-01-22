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

class GetChatsForUser extends ChatEvent {}

class PopChatRouteEvent extends ChatEvent {}

class GetMembersOfChatEvent extends ChatEvent {
  final ChatModel chatModel;

  GetMembersOfChatEvent({required this.chatModel});
}
