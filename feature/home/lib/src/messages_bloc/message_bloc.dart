import 'dart:async';

import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:home/src/navigation/router.dart';
import 'package:navigation/app_router/app_router.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesForChatUseCase _getMessagesForChatUseCase;
  final PostMessageUseCase _postMessageUseCase;
  final GetUserUseCase _getUserUseCase;
  final AppRouter _router;
  MessageBloc(
      {required GetMessagesForChatUseCase getMessagesForChatUseCase,
      required PostMessageUseCase postMessageUseCase,
      required AppRouter router,
      required GetUserUseCase getUserUseCase})
      : _getMessagesForChatUseCase = getMessagesForChatUseCase,
        _postMessageUseCase = postMessageUseCase,
        _router = router,
        _getUserUseCase = getUserUseCase,
        super(MessageLoadingState()) {
    on<InitMessageEvent>(_init);
    on<PostMessageToDBEvent>(_postMessage);
    on<NavigateToChatSettingsEvent>(_navigateToSettingsView);
    on<PopChatSettingsViewEvent>(_popChatSettingsView);
    on<MessagesHasBeenUpdatedEvent>(_updateListOfMessages);
    on<DisposeMessagesBlocEvent>(_dispose);
  }

  void _init(
    InitMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    UserModel currentUser = await _getUserUseCase.execute(NoParams());

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
      listOfMessageModel: [],
      currentUser: currentUser,
    ));
  }

  Future<void> _postMessage(
    PostMessageToDBEvent event,
    Emitter<MessageState> emit,
  ) async {
    await _postMessageUseCase.execute(event.messageModel);
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

  void _navigateToSettingsView(
    NavigateToChatSettingsEvent event,
    Emitter<MessageState> emit,
  ) {
    _router.push(const ChatSettingsRoute());
  }

  void _popChatSettingsView(
    PopChatSettingsViewEvent event,
    Emitter<MessageState> emit,
  ) {
    _router.pop();
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
