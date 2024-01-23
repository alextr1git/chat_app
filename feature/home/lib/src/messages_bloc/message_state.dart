part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final List<MessageModel> listOfMessageModel;

  MessageLoadedState({required this.listOfMessageModel});
}
