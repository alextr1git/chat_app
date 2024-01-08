import 'package:auth/auth.dart';
import 'package:auth/src/views/login_view.dart';
import 'package:auth/src/views/register_view.dart';
import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class StartAuthView extends StatelessWidget {
  const StartAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, AuthState state) {
          if (state.isLoaded) {
            //authBloc.add(NavigateToHomePageEvent) TODO add actual homepage nav
          }
        },
        builder: (_, AuthState state) {
          if (state.authView == AuthView.register) {
            return const RegisterView();
          } else if (state.authView == AuthView.login) {
            return const LoginView();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
