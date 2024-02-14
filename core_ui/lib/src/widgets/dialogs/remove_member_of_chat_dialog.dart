import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showRemoveMemberDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: LocaleKeys.remove_member_dialog_title.tr(),
    content: LocaleKeys.remove_member_dialog_content.tr(),
    optionsBuilder: () => {
      LocaleKeys.remove_member_dialog_leave_option.tr(): true,
      LocaleKeys.remove_member_dialog_cancel_option.tr(): false,
    },
  ).then((value) => value ?? false);
}
