import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/bloc/chat_bloc.dart';
import 'package:navigation/navigation.dart';

import '../widgets/users_list_cell.dart';

@RoutePage()
class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(GetChatsForUser());
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        LocaleKeys.chats_title.tr(),
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: lightTheme.colorScheme.background,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                chatBloc.add(NavigateToAddChatViewEvent());

                                /* MessageModel messageModel = const MessageModel(
                                  id: "jknkj1234",
                                  chatId: "jkjkjkl2134",
                                  senderId: "kjnkjjk2134",
                                  message: "Hello my friend!",
                                  timeStamp: 124124124124124,
                                );
                                try {
                                  context
                                      .read<ChatBloc>()
                                      .add(PostMessageToDBEvent(
                                        messageModel: messageModel,
                                      ));
                                } catch (e) {
                                  print(e.toString());
                                }*/
                              },
                              child: Icon(
                                Icons.add,
                                color: lightTheme.colorScheme.onBackground,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: LocaleKeys.chats_search.tr(),
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 25,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.chatsOfUser!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final chat = state.chatsOfUser![index];
                      return UserInListCell(chat: chat);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
