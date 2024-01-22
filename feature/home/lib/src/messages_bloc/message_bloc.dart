import 'dart:async';

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
  final AppRouter _router;
  MessageBloc({
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required PostMessageUseCase postMessageUseCase,
    required AppRouter router,
  })  : _getMessagesForChatUseCase = getMessagesForChatUseCase,
        _postMessageUseCase = postMessageUseCase,
        _router = router,
        super(MessageLoadingState()) {
    on<PostMessageToDBEvent>(_postMessage);
    on<GetMessagesForChatEvent>(_getMessagesForChat);
    on<NavigateToChatSettingsEvent>(_navigateToSettingsView);
    on<PopChatSettingsViewEvent>(_popChatSettingsView);
  }
  Future<void> _postMessage(
    PostMessageToDBEvent event,
    Emitter<MessageState> emit,
  ) async {
    await _postMessageUseCase.execute(event.messageModel);
  }

  void _getMessagesForChat(
    GetMessagesForChatEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageLoadingState());
    emit(MessageLoadedState(
        messageModelsStream:
            _getMessagesForChatUseCase.execute(event.currentChat)));
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
}
