part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class NavigateToPersonalChatViewEvent extends ChatEvent {
  final ChatModel selectedChat;

  NavigateToPersonalChatViewEvent({required this.selectedChat});
}

class NavigateToAddChatViewEvent extends ChatEvent {}

class PostMessageToDBEvent extends ChatEvent {
  final MessageModel messageModel;

  PostMessageToDBEvent({
    required this.messageModel,
  });
}

class CreateNewChatEvent extends ChatEvent {
  final ChatModel chatModel;

  CreateNewChatEvent({required this.chatModel});
}

class GetMessagesForChatEvent extends ChatEvent {
  final ChatModel chatModel;

  GetMessagesForChatEvent({required this.chatModel});
}

class GetChatsForUser extends ChatEvent {}
