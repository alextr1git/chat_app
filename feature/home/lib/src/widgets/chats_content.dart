import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';

class ChatsContent extends StatefulWidget {
  const ChatsContent({super.key});

  @override
  State<ChatsContent> createState() => _ChatsContentState();
}

class _ChatsContentState extends State<ChatsContent> {
  late final ChatsBloc chatBloc;
  late final TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatsBloc>(context);
    _searchTextController = TextEditingController();
    chatBloc.add(InitChatsEvent());
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                          color: Colors.blue[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                chatBloc.add(NavigateToAddChatViewEvent());
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
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
                  controller: _searchTextController,
                  onChanged: (text) => chatBloc.add(
                      SearchInChatsEvent(query: _searchTextController.text)),
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
              BlocBuilder<ChatsBloc, ChatsState>(
                builder: (context, state) {
                  switch (state) {
                    case ChatsAllDataFetchedState _:
                      return ListView.builder(
                        itemCount: state.listOfFilteredChatsOfUser.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final chat = state.listOfFilteredChatsOfUser[index];
                          final message = state.lastMessagesForChats[chat.id];
                          return ChatsInListCell(
                            chat: chat,
                            message: message,
                          );
                        },
                      );
                    case ChatsDataFetchingState _:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ChatsErrorState _:
                      return Center(
                        child: Text(state.error!),
                      );
                    default:
                      return const Center(
                        child: Text("Something went wrong :("),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
