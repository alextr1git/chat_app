import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout",
    content: "Are you sure you want to log out?",
    optionsBuilder: () => {
      "Ok": true,
      "Cancel": false,
    },
  ).then((value) => value ?? false);
}
