import 'dart:async';

import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/navigation/router.dart';
import 'package:navigation/navigation.dart';
import 'package:domain/domain.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AppRouter _router;

  final CreateNewChatUseCase _createNewChatUseCase;

  final GetChatsForUserUseCase _getChatsForUserUseCase;

  ChatBloc({
    required AppRouter router,
    required PostMessageUseCase postMessageUseCase,
    required CreateNewChatUseCase createNewChatUseCase,
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required GetChatsForUserUseCase getChatsForUserUseCase,
  })  : _router = router,
        _createNewChatUseCase = createNewChatUseCase,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        super(const ChatState(
          currentChat: null,
          chatsOfUser: [],
        )) {
    on<CreateNewChatEvent>(_createNewChat);
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<NavigateToAddChatViewEvent>(_navigateToAddChatView);
    on<GetChatsForUser>(_getChatsForUser);
  }

  Future<void> _createNewChat(
    CreateNewChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _createNewChatUseCase.execute(event.chatModel);
    emit(
      state.copyWith(
        currentChat: event.chatModel,
      ),
    );
    _router.pop();
    _router.push(PersonalChatRoute(chatModel: event.chatModel));
  }

  void _getChatsForUser(
    GetChatsForUser event,
    Emitter<ChatState> emit,
  ) async {
    List<ChatModel> chatModels =
        await _getChatsForUserUseCase.execute(const NoParams());
    emit(
      state.copyWith(chatsOfUser: chatModels),
    );
  }

  Future<void> _navigateToPersonalChatView(
    NavigateToPersonalChatViewEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(currentChat: event.selectedChat),
    );
    _router.push(PersonalChatRoute(chatModel: event.selectedChat));
  }

  Future<void> _navigateToAddChatView(
    _,
    Emitter<ChatState> emit,
  ) async {
    _router.push(const AddChatRoute());
  }
}
