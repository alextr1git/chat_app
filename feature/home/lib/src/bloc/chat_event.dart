part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class NavigateToPersonalChatViewEvent extends ChatEvent {}

class PostMessageToDBEvent extends ChatEvent {
  final MessageModel messageModel;

  PostMessageToDBEvent({
    required this.messageModel,
  });
}
