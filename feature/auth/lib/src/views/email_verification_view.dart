import 'package:auth/auth.dart';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.verify_email_title.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.verify_email_link_has_been_sent.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.verify_email_after_verification.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              LocaleKeys.verify_email_resend_email_label.tr(),
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => authBloc.add(SendVerificationEmailEvent()),
                child: Text(LocaleKeys.verify_email_resend_email_button.tr())),
          ],
        ),
      ),
    );
  }
}
