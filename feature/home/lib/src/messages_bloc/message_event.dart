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
  final ChatModel chatModel;

  GetMessagesForChatEvent({required this.chatModel});
}
