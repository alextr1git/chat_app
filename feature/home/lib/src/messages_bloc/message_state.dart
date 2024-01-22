part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final Stream<MessageModel> messageModelsStream;

  MessageLoadedState({required this.messageModelsStream});
}
