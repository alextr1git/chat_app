import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showRemoveMemberDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: "Remove member",
    content: "Are you sure you want to remove this member?",
    optionsBuilder: () => {
      "Remove": true,
      "Cancel": false,
    },
  ).then((value) => value ?? false);
}
