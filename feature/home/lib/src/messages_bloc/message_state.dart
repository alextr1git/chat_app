part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageInitState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final UserModel currentUser;
  final List<MessageModel> listOfMessageModel;

  MessageLoadedState({
    required this.listOfMessageModel,
    required this.currentUser,
  });

  MessageLoadedState copyWith({
    UserModel? currentUser,
    List<MessageModel>? listOfMessageModel,
  }) =>
      MessageLoadedState(
        listOfMessageModel: listOfMessageModel ?? this.listOfMessageModel,
        currentUser: currentUser ?? this.currentUser,
      );
}
