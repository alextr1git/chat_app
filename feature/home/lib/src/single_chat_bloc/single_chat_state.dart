part of 'single_chat_bloc.dart';

@immutable
abstract class SingleChatState {}

class SingleChatInitial extends SingleChatState {}

class SingleChatFetchingDataState extends SingleChatState {}

class ChatsSingleChatDataFetchedState extends SingleChatState {
  final ChatModel currentChat;
  final UserModel currentUser;
  final List<ChatMemberModel> activeMembersOfChat;
  final List<ChatMemberModel> allMembersOfChat;

  ChatsSingleChatDataFetchedState({
    required this.currentChat,
    required this.activeMembersOfChat,
    required this.allMembersOfChat,
    required this.currentUser,
  });
}

class ChatsSingleChatDataErrorState extends SingleChatState {
  final String errorMessage;

  ChatsSingleChatDataErrorState({required this.errorMessage});
}
