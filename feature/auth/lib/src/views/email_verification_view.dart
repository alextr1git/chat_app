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
        title: const Text("Verify your email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "An email with verification link has been sent to your email address.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "After verification you will be able to log in to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "If you haven't received, please press on button below",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => authBloc.add(SendVerificationEmailEvent()),
                child: const Text("Resend email")),
          ],
        ),
      ),
    );
  }
}
