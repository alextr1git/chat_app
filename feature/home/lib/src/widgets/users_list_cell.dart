import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/bloc/chat_bloc.dart';

class UserListCell extends StatefulWidget {
  final String _name;
  final String _messageText;
  final File? _image;
  final String _time;
  const UserListCell({
    super.key,
    required name,
    required messageText,
    required image,
    required time,
  })  : _name = name,
        _messageText = messageText,
        _image = image,
        _time = time;
  @override
  UserListCellState createState() => UserListCellState();
}

class UserListCellState extends State<UserListCell> {
  @override
  Widget build(BuildContext context) {
    final ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    return GestureDetector(
      onTap: () {
        chatBloc.add(NavigateToPersonalChatViewEvent());
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: widget._image != null
                        ? FileImage(widget._image!)
                        : null,
                    maxRadius: 30,
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
                            widget._name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget._messageText,
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
              widget._time,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
