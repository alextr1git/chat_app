import 'dart:async';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesForChatUseCase _getMessagesForChatUseCase;
  final PostMessageUseCase _postMessageUseCase;
  final GetUserUseCase _getUserUseCase;
  final GetUsernameByIDUseCase _getUsernameByIDUseCase;

  MessageBloc(
      {required GetMessagesForChatUseCase getMessagesForChatUseCase,
      required PostMessageUseCase postMessageUseCase,
      required GetUserUseCase getUserUseCase,
      required GetUsernameByIDUseCase getUsernameByIDUseCase})
      : _getMessagesForChatUseCase = getMessagesForChatUseCase,
        _postMessageUseCase = postMessageUseCase,
        _getUserUseCase = getUserUseCase,
        _getUsernameByIDUseCase = getUsernameByIDUseCase,
        super(MessageLoadingState()) {
    on<InitMessageEvent>(_init);
    on<PostMessageToDBEvent>(_postMessage);
    on<PostServiceMessageToDBEvent>(_postServiceMessage);

    on<MessagesHasBeenUpdatedEvent>(_updateListOfMessages);
    on<DisposeMessagesBlocEvent>(_dispose);
  }

  void _init(
    InitMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    UserModel currentUser = await _getUserUseCase.execute(const NoParams());

    StreamSubscription<List<MessageModel>> subscriptionOfMessageModels =
        _getMessagesForChatUseCase
            .execute(event.currentChat)
            .listen((listOfMessages) {
      add(MessagesHasBeenUpdatedEvent(
        updatedListOfMessages: listOfMessages,
        currentUser: currentUser,
      ));
    });
    emit(MessageLoadedState(
      subscription: subscriptionOfMessageModels,
      listOfMessageModel: const [],
      currentUser: currentUser,
    ));
  }

  Future<void> _postMessage(
    PostMessageToDBEvent event,
    Emitter<MessageState> emit,
  ) async {
    await _postMessageUseCase.execute(event.messageModel);
  }

  Future<void> _postServiceMessage(
    PostServiceMessageToDBEvent event,
    Emitter<MessageState> emit,
  ) async {
    final UserModel userModel = await _getUserUseCase.execute(const NoParams());
    final String username = event.username == null
        ? await _getUsernameByIDUseCase.execute(userModel.id)
        : event.username!;
    String message = "";
    switch (event.serviceType) {
      case "remove":
        message = "$username has been kicked by the creator";
        break;
      case "leave":
        message = "$username has left the chat";
        break;
      case "join":
        message = "$username joined the chat via link";
        break;
      default:
        break;
    }
    MessageModel messageModel = MessageModel(
      id: "0",
      chatId: event.chatID,
      senderId: "service",
      message: message,
      timeStamp: event.timestamp,
    );
    await _postMessageUseCase.execute(messageModel);
  }

  void _updateListOfMessages(
    MessagesHasBeenUpdatedEvent event,
    Emitter<MessageState> emit,
  ) {
    if (state is MessageLoadedState) {
      emit(
        (state as MessageLoadedState).copyWith(
          listOfMessageModel: event.updatedListOfMessages,
          currentUser: event.currentUser,
        ),
      );
    }
  }

  void _dispose(
    _,
    Emitter<MessageState> emit,
  ) {
    if (state is MessageLoadedState) {
      (state as MessageLoadedState).subscription.cancel();
    }
    emit(MessageInitState());
  }
}
