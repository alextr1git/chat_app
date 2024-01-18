import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/navigation/router.dart';
import 'package:navigation/navigation.dart';
import 'package:domain/domain.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AppRouter _router;
  final PostMessageUseCase _postMessageUseCase;
  ChatBloc(
      {required AppRouter router,
      required PostMessageUseCase postMessageUseCase})
      : _router = router,
        _postMessageUseCase = postMessageUseCase,
        super(ChatInitial()) {
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<PostMessageToDBEvent>(_postMessage);
  }

  Future<void> _postMessage(
    PostMessageToDBEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _postMessageUseCase.execute(event.messageModel);
  }

  Future<void> _navigateToPersonalChatView(
    _,
    Emitter<ChatState> emit,
  ) async {
    _router.push(const PersonalChatRoute());
  }
}
