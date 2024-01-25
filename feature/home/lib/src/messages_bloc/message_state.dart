part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageInitState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final StreamSubscription<List<MessageModel>> subscription;
  final UserModel currentUser;
  final List<MessageModel> listOfMessageModel;

  MessageLoadedState({
    required this.subscription,
    required this.listOfMessageModel,
    required this.currentUser,
  });

  MessageLoadedState copyWith({
    StreamSubscription<List<MessageModel>>? subscription,
    UserModel? currentUser,
    List<MessageModel>? listOfMessageModel,
  }) =>
      MessageLoadedState(
        subscription: subscription ?? this.subscription,
        listOfMessageModel: listOfMessageModel ?? this.listOfMessageModel,
        currentUser: currentUser ?? this.currentUser,
      );
}
