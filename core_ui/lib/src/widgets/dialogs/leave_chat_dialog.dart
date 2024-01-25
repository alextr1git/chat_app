import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLeaveChatDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: "Leave the chat",
    content: "Are you sure you want to leave this chat?",
    optionsBuilder: () => {
      "Leave": true,
      "Cancel": false,
    },
  ).then((value) => value ?? false);
}
