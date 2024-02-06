import 'dart:async';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/src/navigation/router.dart';
import 'package:navigation/navigation.dart';
import 'package:domain/domain.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final AppRouter _router;
  final GetChatsForUserUseCase _getChatsForUserUseCase;
  final GetLastsMessagesOfChatUseCase _getLastMessageOfChatUseCase;
  final SetListeningStatusUseCase _inverseListeningStatusUseCase;
  late final StreamSubscription<List<ChatModel>> _subscriptionOfChatEntities;

  ChatsBloc(
      {required AppRouter router,
      required GetChatsForUserUseCase getChatsForUserUseCase,
      required GetLastsMessagesOfChatUseCase getLastMessageOfChatUseCase,
      required SetListeningStatusUseCase inverseListeningStatusUseCase})
      : _router = router,
        _getChatsForUserUseCase = getChatsForUserUseCase,
        _getLastMessageOfChatUseCase = getLastMessageOfChatUseCase,
        _inverseListeningStatusUseCase = inverseListeningStatusUseCase,
        super(ChatsDataFetchingState()) {
    on<NavigateToPersonalChatViewEvent>(_navigateToPersonalChatView);
    on<NavigateToAddChatViewEvent>(_navigateToAddChatView);
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
        _updateStatusForEveryChat(
            listOfChatModels: listOfChatModels, status: true);
        add(ChatsHasBeenUpdatedEvent(
          updatedListOfChatModels: listOfChatModels,
        ));
      } catch (e) {
        //throw StreamAddsEventButBlocIsDisposedException();
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
    _updateStatusForEveryChat(
      listOfChatModels:
          (state as ChatsAllDataFetchedState).listOfAllChatsOfUser,
      status: false,
    );
    _router.replace(PersonalChatRoute(chatModel: event.selectedChat));
  }

  void _updateStatusForEveryChat({
    required List<ChatModel> listOfChatModels,
    required bool status,
  }) {
    for (ChatModel chatModel in listOfChatModels) {
      Map<String, bool> mapOfChatToStatus = {chatModel.id: status};
      _inverseListeningStatusUseCase.execute(mapOfChatToStatus);
    }
  }

  Future<void> _navigateToAddChatView(
    _,
    Emitter<ChatsState> emit,
  ) async {
    _subscriptionOfChatEntities.cancel();
    _updateStatusForEveryChat(
      listOfChatModels:
          (state as ChatsAllDataFetchedState).listOfAllChatsOfUser,
      status: false,
    );
    _router.replace(const AddChatRoute());
  }

  Future<void> _dispose(
    _,
    Emitter<ChatsState> emit,
  ) async {
    emit(ChatsDataFetchingState());
  }
}
