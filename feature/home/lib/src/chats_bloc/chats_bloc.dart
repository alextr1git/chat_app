import 'dart:async';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/navigation/router.dart';
import 'package:navigation/navigation.dart';
import 'package:domain/domain.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final AppRouter _router;
  final GetChatsForUserUseCase _getChatsForUserUseCase;
  final GetLastsMessagesOfChatUseCase _getLastMessageOfChatUseCase;
  late final StreamSubscription<List<ChatModel>> _subscriptionOfChatEntities;

  ChatsBloc({
    required AppRouter router,
    required GetChatsForUserUseCase getChatsForUserUseCase,
    required GetLastsMessagesOfChatUseCase getLastMessageOfChatUseCase,
  })  : _router = router,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        _getLastMessageOfChatUseCase = getLastMessageOfChatUseCase,
        super(ChatsDataFetchingState()) {
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<NavigateToAddChatViewEvent>(_navigateToAddChatView);
    // on<GetChatsForUser>(_getChatsForUser);
    on<DisposeChatBlocEvent>(_dispose);
    on<SearchInChatsEvent>(_searchChat);
    on<ChatsHasBeenUpdatedEvent>(_updateListOfChatModels);
    on<InitChatsEvent>(_init);
  }

  void _init(
    InitChatsEvent event,
    Emitter<ChatsState> emit,
  ) async {
    _subscriptionOfChatEntities = _getChatsForUserUseCase
        .execute(const NoParams())
        .listen((listOfChatModels) {
      try {
        add(ChatsHasBeenUpdatedEvent(
          updatedListOfChatModels: listOfChatModels,
        ));
      } catch (e) {
        print(e.toString());
      }
    });

    emit(ChatsDataFetchingState());
  }

  Future<void> _updateListOfChatModels(
    ChatsHasBeenUpdatedEvent event,
    Emitter<ChatsState> emit,
  ) async {
    var mapOfChatModelsToMessageModels = await _getLastMessageOfChatUseCase
        .execute(event.updatedListOfChatModels);

    emit(ChatsAllDataFetchedState(
      listOfAllChatsOfUser: event.updatedListOfChatModels,
      listOfFilteredChatsOfUser: event.updatedListOfChatModels,
      lastMessagesForChats: mapOfChatModelsToMessageModels,
    ));
  }

  void _searchChat(
    SearchInChatsEvent event,
    Emitter<ChatsState> emit,
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

  Future<void> _navigateToPersonalChatView(
    NavigateToPersonalChatViewEvent event,
    Emitter<ChatsState> emit,
  ) async {
    _subscriptionOfChatEntities.cancel();
    _router.replace(PersonalChatRoute(chatModel: event.selectedChat));
  }

  Future<void> _navigateToAddChatView(
    _,
    Emitter<ChatsState> emit,
  ) async {
    _subscriptionOfChatEntities.cancel();
    _router.replace(const AddChatRoute());
  }

  Future<void> _dispose(
    _,
    Emitter<ChatsState> emit,
  ) async {
    emit(ChatsDataFetchingState());
  }
}
