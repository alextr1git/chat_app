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
  final GetMembersOfChatUsecase _getMembersOfChatUsecase;
  final JoinChatUseCase _joinChatUseCase;
  final RemoveUserFromChatUseCase _removeUserFromChatUseCase;

  ChatBloc({
    required AppRouter router,
    required PostMessageUseCase postMessageUseCase,
    required CreateNewChatUseCase createNewChatUseCase,
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required GetChatsForUserUseCase getChatsForUserUseCase,
    required GetMembersOfChatUsecase getMembersOfChatUsecase,
    required JoinChatUseCase joinChatUseCase,
    required RemoveUserFromChatUseCase removeUserFromChatUseCase,
  })  : _router = router,
        _createNewChatUseCase = createNewChatUseCase,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        _getMembersOfChatUsecase = getMembersOfChatUsecase,
        _joinChatUseCase = joinChatUseCase,
        _removeUserFromChatUseCase = removeUserFromChatUseCase,
        super(const ChatState(
          currentChat: null,
          chatsOfUser: [],
        )) {
    on<CreateNewChatEvent>(_createNewChat);
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<NavigateToAddChatViewEvent>(_navigateToAddChatView);
    on<GetChatsForUser>(_getChatsForUser);
    on<PopChatRouteEvent>(_popChatRouteEvent);
    on<GetMembersOfChatEvent>(_getMembersOfChat);
    on<JoinChatEvent>(_joinChat);
    on<RemoveUserFromChatEvent>(_removeUserFromChat);
  }

  Future<void> _createNewChat(
    CreateNewChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? createdChatModel =
        await _createNewChatUseCase.execute(event.chatTitle);
    if (createdChatModel != null) {
      emit(
        state.copyWith(
          currentChat: createdChatModel,
        ),
      );
      _router.pop();
      _router.push(PersonalChatRoute(chatModel: createdChatModel));
    }
  }

  Future<void> _joinChat(
    JoinChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? chatModel = await _joinChatUseCase.execute(event.chatID);
    if (chatModel != null) {
      _router.pop();
      _router.push(PersonalChatRoute(chatModel: chatModel));
    }
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

  Future<void> _getMembersOfChat(
    GetMembersOfChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    List<ChatMemberModel> listOfChatMemberModels =
        await _getMembersOfChatUsecase.execute(event.chatModel.id);
    emit(
      state.copyWith(membersOfChat: listOfChatMemberModels),
    );
  }

  Future<void> _removeUserFromChat(
    RemoveUserFromChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final String userID = event.userID;
    final String chatID = event.chatID;
    if (userID != null && chatID != null) {
      Map<String, String> mapOfRemoveUser = {
        "userID": userID,
        "chatID": chatID,
      };
      await _removeUserFromChatUseCase.execute(mapOfRemoveUser);
      add(GetMembersOfChatEvent(chatModel: state.currentChat!));
    }
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

  Future<void> _popChatRouteEvent(
    _,
    Emitter<ChatState> emit,
  ) async {
    _router.pop();
  }
}
