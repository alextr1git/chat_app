part of 'single_chat_bloc.dart';

@immutable
abstract class SingleChatEvent {}

class CreateNewChatEvent extends SingleChatEvent {
  final ChatModel chatModel;

  CreateNewChatEvent({required this.chatModel});
}

class JoinChatEvent extends SingleChatEvent {
  final String chatID;

  JoinChatEvent({required this.chatID});
}

class RemoveUserFromChatEvent extends SingleChatEvent {
  final String userID;
  final ChatModel chat;

  RemoveUserFromChatEvent({
    required this.userID,
    required this.chat,
  });
}

class GetMembersOfChatEvent extends SingleChatEvent {
  final ChatModel chatModel;

  GetMembersOfChatEvent({required this.chatModel});
}

class NavigateToCreatedChatViewEvent extends SingleChatEvent {
  final ChatModel newChat;

  NavigateToCreatedChatViewEvent({required this.newChat});
}

class NavigateToChatsViewEvent extends SingleChatEvent {}

class NavigateToChatSettingsEvent extends SingleChatEvent {
  final ChatModel currentChat;
  final SingleChatBloc singleChatBloc;

  NavigateToChatSettingsEvent({
    required this.currentChat,
    required this.singleChatBloc,
  });
}

class PopChatSettingsViewEvent extends SingleChatEvent {}

class PopSingleChatRouteEvent extends SingleChatEvent {}

class PopAddChatRouteEvent extends SingleChatEvent {}
