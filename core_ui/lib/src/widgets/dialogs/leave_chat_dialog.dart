import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLeaveChatDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: LocaleKeys.leave_chat_dialog_title.tr(),
    content: LocaleKeys.leave_chat_dialog_content.tr(),
    optionsBuilder: () => {
      LocaleKeys.leave_chat_dialog_leave_option.tr(): true,
      LocaleKeys.leave_chat_dialog_cancel_option.tr(): false,
    },
  ).then((value) => value ?? false);
}
