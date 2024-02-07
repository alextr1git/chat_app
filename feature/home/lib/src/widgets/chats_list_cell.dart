import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';

class ChatsInListCell extends StatefulWidget {
  final ChatModel chat;
  final MessageModel? message;

  const ChatsInListCell({
    super.key,
    required this.chat,
    required this.message,
  });

  @override
  State<ChatsInListCell> createState() => _ChatsInListCellState();
}

class _ChatsInListCellState extends State<ChatsInListCell> {
  late final ChatsBloc chatBloc;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatsBloc>(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        chatBloc
            .add(NavigateToPersonalChatViewEvent(selectedChat: widget.chat));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(widget.chat.color),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24))),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.chat.title,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            (widget.message != null
                                ? widget.message!.message
                                : LocaleKeys.chats_no_messages.tr()),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (widget.message != null
                  ? DateFormat('MM/dd hh:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          widget.message!.timeStamp))
                      .toString()
                  : ""),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
