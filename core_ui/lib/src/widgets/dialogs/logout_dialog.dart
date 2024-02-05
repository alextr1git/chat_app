import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: LocaleKeys.log_out_dialog_title.tr(),
    content: LocaleKeys.log_out_dialog_content.tr(),
    optionsBuilder: () => {
      LocaleKeys.log_out_dialog_leave_option.tr(): true,
      LocaleKeys.log_out_dialog_cancel_option.tr(): false,
    },
  ).then((value) => value ?? false);
}
