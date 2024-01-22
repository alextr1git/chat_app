part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class PostMessageToDBEvent extends MessageEvent {
  final MessageModel messageModel;

  PostMessageToDBEvent({
    required this.messageModel,
  });
}

class GetMessagesForChatEvent extends MessageEvent {
  final ChatModel currentChat;

  GetMessagesForChatEvent({required this.currentChat});
}

class NavigateToChatSettingsEvent extends MessageEvent {
  final ChatModel currentChat;

  NavigateToChatSettingsEvent({required this.currentChat});
}

class PopChatSettingsViewEvent extends MessageEvent {}
