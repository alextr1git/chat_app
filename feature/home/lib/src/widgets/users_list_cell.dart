/*/*
import 'package:flutter/material.dart';

import '../../home.dart';

typedef ChatsCallback = void Function(MockUser user);

class UserInListCell extends StatelessWidget {
  final MockUser userMock;
  final ChatsCallback onTap;
  const UserInListCell({
    super.key,
    required this.userMock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(userMock);
      },
      title: Text(
        userMock.name,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.verified_user),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/bloc/chat_bloc.dart';

import '../../home.dart';

typedef ChatsCallback = void Function(MockUser user);

class UserListCell extends StatefulWidget {
  final MockUser _user;
  final ChatsCallback onTap;

  const UserListCell({
    super.key,
    required user,
    required this.onTap,
  }) : _user = user;
  @override
  UserListCellState createState() => UserListCellState();
}

class UserListCellState extends State<UserListCell> {
  @override
  Widget build(BuildContext context) {
    final ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    return GestureDetector(
      onTap: () {
        onTap(_user);
        //  chatBloc.add(NavigateToPersonalChatViewEvent());
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


*/

*/
