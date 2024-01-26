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
  final GetUserUseCase _getUserUseCase;

  ChatBloc({
    required AppRouter router,
    required PostMessageUseCase postMessageUseCase,
    required CreateNewChatUseCase createNewChatUseCase,
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required GetChatsForUserUseCase getChatsForUserUseCase,
    required GetMembersOfChatUsecase getMembersOfChatUsecase,
    required JoinChatUseCase joinChatUseCase,
    required RemoveUserFromChatUseCase removeUserFromChatUseCase,
    required GetUserUseCase getUserUseCase,
  })  : _router = router,
        _createNewChatUseCase = createNewChatUseCase,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        _getMembersOfChatUsecase = getMembersOfChatUsecase,
        _joinChatUseCase = joinChatUseCase,
        _removeUserFromChatUseCase = removeUserFromChatUseCase,
        _getUserUseCase = getUserUseCase,
        super(const ChatState(
          error: null,
          currentChat: null,
          chatsOfUser: [],
          activeMembersOfChat: [],
          allMembersOfChat: [],
        )) {
    on<CreateNewChatEvent>(_createNewChat);
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<NavigateToAddChatViewEvent>(_navigateToAddChatView);
    on<GetChatsForUser>(_getChatsForUser);
    on<PopChatRouteEvent>(_popChatRouteEvent);
    on<JoinChatEvent>(_joinChat);
    on<RemoveUserFromChatEvent>(_removeUserFromChat);
    on<GetMembersOfChatEvent>(_getMembersOfChat);
    on<DisposeChatBlocEvent>(_dispose);
    on<NavigateToChatsViewEvent>(_navigateToChatsView);
  }

  Future<void> _createNewChat(
    CreateNewChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? createdChatModel =
        await _createNewChatUseCase.execute(event.chatModel);
    if (createdChatModel != null) {
      add(PopChatRouteEvent());
      add(GetMembersOfChatEvent(chatModel: createdChatModel));
      add(NavigateToPersonalChatViewEvent(selectedChat: createdChatModel));
      add(GetChatsForUser());
    }
  }

  Future<void> _joinChat(
    JoinChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? chatModel = await _joinChatUseCase.execute(event.chatID);

    if (chatModel != null) {
      emit(state.copyWith(
        error: null,
      ));
      add(GetChatsForUser()); // cause when we join chat and then pop view we should see updated list
    } else {
      emit(state.copyWith(
        error: "Cannot find chat by provided link",
      ));
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

  Future<void> _removeUserFromChat(
    RemoveUserFromChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    bool isDeleteChat = false;
    String userID = event.userID;
    final String chatID = event.chat.id;
    if (userID != null && chatID != null) {
      if (userID == "self") {
        isDeleteChat = true;
        UserModel userModel = await _getUserUseCase.execute(NoParams());
        userID = userModel.id;
      }
      Map<String, String> mapOfRemoveUser = {
        "userID": userID,
        "chatID": chatID,
      };
      await _removeUserFromChatUseCase.execute(mapOfRemoveUser);

      if (!isDeleteChat) {
        //if the member has been kicked out from chat
        add(PopChatRouteEvent());
      } else {
        //if the chat has been deleted
        add(NavigateToChatsViewEvent());
      }
    }
  }

  Future<void> _getMembersOfChat(
    GetMembersOfChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    List<ChatMemberModel> listOfActiveChatMemberModels = [];
    List<ChatMemberModel> listOfChatMemberModels =
        await _getMembersOfChatUsecase.execute(event.chatModel.id);
    for (var member in listOfChatMemberModels) {
      if (member.isMember) {
        listOfActiveChatMemberModels.add(member);
      }
    }
    emit(
      state.copyWith(
        allMembersOfChat: listOfChatMemberModels,
        activeMembersOfChat: listOfActiveChatMemberModels,
      ),
    );
  }

  Future<void> _navigateToPersonalChatView(
    NavigateToPersonalChatViewEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        currentChat: event.selectedChat,
      ),
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

  Future<void> _dispose(
    _,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      chatsOfUser: [],
      activeMembersOfChat: [],
      allMembersOfChat: [],
      currentChat: null,
    ));
  }

  Future<void> _navigateToChatsView(
    _,
    Emitter<ChatState> emit,
  ) async {
    _router.replace(const SharedNavbarRoute());
  }
}
