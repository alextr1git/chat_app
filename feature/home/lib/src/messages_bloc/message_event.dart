part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class InitMessageEvent extends MessageEvent {
  final ChatModel currentChat;
  /*final StreamSubscription<List<MessageModel>> streamSubscription;*/

  InitMessageEvent({required this.currentChat});
}

class PostMessageToDBEvent extends MessageEvent {
  final MessageModel messageModel;

  PostMessageToDBEvent({
    required this.messageModel,
  });
}

class PostServiceMessageToDBEvent extends MessageEvent {
  final String chatID;
  final String? username;
  final num timestamp;
  final String serviceType;

  PostServiceMessageToDBEvent(
      {required this.chatID,
      required this.timestamp,
      required this.username,
      required this.serviceType});
}

class NavigateToChatSettingsEvent extends MessageEvent {
  final ChatModel currentChat;

  NavigateToChatSettingsEvent({required this.currentChat});
}

class PopChatSettingsViewEvent extends MessageEvent {}

class MessagesHasBeenUpdatedEvent extends MessageEvent {
  final List<MessageModel> updatedListOfMessages;
  final UserModel currentUser;
  MessagesHasBeenUpdatedEvent({
    required this.updatedListOfMessages,
    required this.currentUser,
  });
}

class DisposeMessagesBlocEvent extends MessageEvent {}
