part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final UserModel currentUser;
  final List<MessageModel> listOfMessageModel;

  MessageLoadedState({
    required this.listOfMessageModel,
    required this.currentUser,
  });
}
