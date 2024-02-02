import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

part 'single_chat_event.dart';
part 'single_chat_state.dart';

class SingleChatBloc extends Bloc<SingleChatEvent, SingleChatState> {
  final AppRouter _router;
  final CreateNewChatUseCase _createNewChatUseCase;
  final GetMembersOfChatUseCase _getMembersOfChatUseCase;
  final JoinChatUseCase _joinChatUseCase;
  final RemoveUserFromChatUseCase _removeUserFromChatUseCase;
  final GetUserUseCase _getUserUseCase;
  SingleChatBloc({
    required AppRouter router,
    required PostMessageUseCase postMessageUseCase,
    required CreateNewChatUseCase createNewChatUseCase,
    required GetMessagesForChatUseCase getMessagesForChatUseCase,
    required GetMembersOfChatUseCase getMembersOfChatUsecase,
    required JoinChatUseCase joinChatUseCase,
    required RemoveUserFromChatUseCase removeUserFromChatUseCase,
    required GetUserUseCase getUserUseCase,
  })  : _router = router,
        _createNewChatUseCase = createNewChatUseCase,
        _getMembersOfChatUseCase = getMembersOfChatUsecase,
        _joinChatUseCase = joinChatUseCase,
        _removeUserFromChatUseCase = removeUserFromChatUseCase,
        _getUserUseCase = getUserUseCase,
        super(SingleChatInitial()) {
    on<CreateNewChatEvent>(_createNewChat);
    on<PopSingleChatRouteEvent>(_popSingleChatRouteEvent);
    on<JoinChatEvent>(_joinChat);
    on<RemoveUserFromChatEvent>(_removeUserFromChat);
    on<GetMembersOfChatEvent>(_getMembersOfChat);
    on<PopAddChatRouteEvent>(_popAddChatRouteEvent);

    on<NavigateToChatsViewEvent>(_navigateToChatsView);
    on<NavigateToCreatedChatViewEvent>(_navigateToCreatedChatView);
    on<NavigateToChatSettingsEvent>(_navigateToSettingsView);
    on<PopChatSettingsViewEvent>(_popChatSettingsView);
  }
  Future<void> _createNewChat(
    CreateNewChatEvent event,
    Emitter<SingleChatState> emit,
  ) async {
    final ChatModel? createdChatModel =
        await _createNewChatUseCase.execute(event.chatModel);
    if (createdChatModel != null) {
      add(NavigateToCreatedChatViewEvent(newChat: createdChatModel));
    }
  }

  Future<void> _joinChat(
    JoinChatEvent event,
    Emitter<SingleChatState> emit,
  ) async {
    final ChatModel? chatModel = await _joinChatUseCase.execute(event.chatID);
    if (chatModel != null) {
      add(NavigateToCreatedChatViewEvent(newChat: chatModel));
    }
  }

  Future<void> _removeUserFromChat(
    RemoveUserFromChatEvent event,
    Emitter<SingleChatState> emit,
  ) async {
    bool isDeleteChat = false;
    String userID = event.userID;
    final String chatID = event.chat.id;
    if (userID != null && chatID != null) {
      if (userID == "self") {
        isDeleteChat = true;
        UserModel userModel = await _getUserUseCase.execute(const NoParams());
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
        add(PopSingleChatRouteEvent());
      } else {
        //if the chat has been deleted
        add(NavigateToChatsViewEvent());
      }
    }
  }

  Future<void> _getMembersOfChat(
    GetMembersOfChatEvent event,
    Emitter<SingleChatState> emit,
  ) async {
    emit(SingleChatFetchingDataState());
    UserModel currentUser = await _getUserUseCase.execute(const NoParams());
    List<ChatMemberModel> listOfActiveChatMemberModels = [];
    List<ChatMemberModel> listOfChatMemberModels =
        await _getMembersOfChatUseCase.execute(event.chatModel.id);
    for (var member in listOfChatMemberModels) {
      if (member.isMember) {
        listOfActiveChatMemberModels.add(member);
      }
    }
    emit(ChatsSingleChatDataFetchedState(
      currentUser: currentUser,
      currentChat: event.chatModel,
      activeMembersOfChat: listOfActiveChatMemberModels,
      allMembersOfChat: listOfChatMemberModels,
    ));
  }

  Future<void> _navigateToChatsView(
    _,
    Emitter<SingleChatState> emit,
  ) async {
    _router.replace(const SharedNavbarRoute());
  }

  Future<void> _navigateToCreatedChatView(
    NavigateToCreatedChatViewEvent event,
    Emitter<SingleChatState> emit,
  ) async {
    _router.replace(PersonalChatRoute(chatModel: event.newChat));
  }

  void _navigateToSettingsView(
    NavigateToChatSettingsEvent event,
    Emitter<SingleChatState> emit,
  ) {
    _router.push(ChatSettingsRoute(chatModel: event.currentChat));
  }

  void _popChatSettingsView(
    PopChatSettingsViewEvent event,
    Emitter<SingleChatState> emit,
  ) {
    _router.pop();
  }

  Future<void> _popSingleChatRouteEvent(
    _,
    Emitter<SingleChatState> emit,
  ) async {
    _router.pop();
  }

  Future<void> _popAddChatRouteEvent(
    _,
    Emitter<SingleChatState> emit,
  ) async {
    _router.replace(const SharedNavbarRoute());
  }
}
