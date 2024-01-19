import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  StreamSubscription<MessageModel>? _streamSubscriptionMessageModel;
  final GetMessagesForChatUseCase _getMessagesForChatUseCase;
  final PostMessageUseCase _postMessageUseCase;
  MessageBloc({
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required PostMessageUseCase postMessageUseCase,
  })  : _getMessagesForChatUseCase = getMessagesForChatUseCase,
        _postMessageUseCase = postMessageUseCase,
        super(MessageState(
            messageModelsStreamController: StreamController(),
            currentChat: null)) {
    on<PostMessageToDBEvent>(_postMessage);
    on<GetMessagesForChatEvent>(_getMessagesForChat);
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
    List<MessageModel> listOfModels = [];
    Stream<MessageModel> messageModelsStream =
        _getMessagesForChatUseCase.execute(event.chatModel);
    messageModelsStream.listen((event) {
      listOfModels.add(event);
    });
    state.messageModelsStreamController.add(listOfModels);
  }
}
