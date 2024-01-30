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
  final GetLastsMessagesOfChatUseCase _getLastMessageOfChatUseCase;

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
    required GetLastsMessagesOfChatUseCase getLastMessageOfChatUseCase,
  })  : _router = router,
        _createNewChatUseCase = createNewChatUseCase,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        _getMembersOfChatUsecase = getMembersOfChatUsecase,
        _joinChatUseCase = joinChatUseCase,
        _removeUserFromChatUseCase = removeUserFromChatUseCase,
        _getUserUseCase = getUserUseCase,
        _getLastMessageOfChatUseCase = getLastMessageOfChatUseCase,
        super(ChatsDataFetchingState()) {
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
    on<SearchInChatEvent>(_searchChat);
    on<PopAddChatRouteEvent>(_popAddChatRouteEvent);
    //on<GetLastMessagesOfChatEvent>(_getLastMessageOfChat);
  }

  Future<void> _createNewChat(
    CreateNewChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? createdChatModel =
        await _createNewChatUseCase.execute(event.chatModel);
    if (createdChatModel != null) {
      add(NavigateToPersonalChatViewEvent(selectedChat: createdChatModel));
    }
  }

  Future<void> _joinChat(
    JoinChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    final ChatModel? chatModel = await _joinChatUseCase.execute(event.chatID);
    if (chatModel != null) {
      add(NavigateToPersonalChatViewEvent(selectedChat: chatModel));
    } else {
      emit(ChatsErrorState(error: "Cannot find chat by provided link"));
    }
  }

  void _getChatsForUser(
    GetChatsForUser event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatsDataFetchingState());
    List<ChatModel> chatModels =
        await _getChatsForUserUseCase.execute(const NoParams());

    Map<String, MessageModel> mapOfChatModelsToMessageModels = {};
    if (chatModels != null) {
      mapOfChatModelsToMessageModels =
          await _getLastMessageOfChatUseCase.execute(chatModels);
      emit(ChatsAllDataFetchedState(
        listOfAllChatsOfUser: chatModels,
        listOfFilteredChatsOfUser: chatModels,
        lastMessagesForChats: mapOfChatModelsToMessageModels,
      ));
    } else {
      emit(ChatsErrorState(error: 'Cannot retrieve data from server'));
    }
  }

  void _searchChat(
    SearchInChatEvent event,
    Emitter<ChatState> emit,
  ) {
    String query = event.query;
    if (state is ChatsAllDataFetchedState) {
      if ((state as ChatsAllDataFetchedState).listOfAllChatsOfUser != null &&
          (state as ChatsAllDataFetchedState)
              .listOfAllChatsOfUser!
              .isNotEmpty) {
        final listOfFoundedElements = (state as ChatsAllDataFetchedState)
            .listOfAllChatsOfUser!
            .where((chat) {
          final chatTitle = chat.title.toLowerCase();
          final searchQuery = query.toLowerCase();
          return chatTitle.contains(searchQuery);
        }).toList();
        emit((state as ChatsAllDataFetchedState).copyWith(
          listOfFilteredChatsOfUser: listOfFoundedElements,
        ));
      }
    }
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

      // add(GetChatsForUser()); // this better be fixed - it doesn't fast enough to rebuild ui after deletion
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
    emit(ChatsDataFetchingState());
    List<ChatMemberModel> listOfActiveChatMemberModels = [];
    List<ChatMemberModel> listOfChatMemberModels =
        await _getMembersOfChatUsecase.execute(event.chatModel.id);
    for (var member in listOfChatMemberModels) {
      if (member.isMember) {
        listOfActiveChatMemberModels.add(member);
      }
    }
    emit(ChatsSingleChatDataFetchedState(
      currentChat: event.chatModel,
      activeMembersOfChat: listOfActiveChatMemberModels,
      allMembersOfChat: listOfChatMemberModels,
    ));
  }

  Future<void> _navigateToPersonalChatView(
    NavigateToPersonalChatViewEvent event,
    Emitter<ChatState> emit,
  ) async {
    _router.replace(PersonalChatRoute(chatModel: event.selectedChat));
  }

  Future<void> _navigateToAddChatView(
    _,
    Emitter<ChatState> emit,
  ) async {
    _router.replace(const AddChatRoute());
  }

  Future<void> _popChatRouteEvent(
    _,
    Emitter<ChatState> emit,
  ) async {
    add(GetChatsForUser());
    _router.pop();
  }

  Future<void> _popAddChatRouteEvent(
    _,
    Emitter<ChatState> emit,
  ) async {
    add(GetChatsForUser());
    _router.replace(const SharedNavbarRoute());
  }

  Future<void> _dispose(
    _,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatsDataFetchingState());
  }

  Future<void> _navigateToChatsView(
    _,
    Emitter<ChatState> emit,
  ) async {
    add(GetChatsForUser());
    _router.replace(const SharedNavbarRoute());
  }
}
