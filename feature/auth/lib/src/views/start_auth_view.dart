import 'package:auth/auth.dart';
import 'package:auth/src/views/email_verification_view.dart';
import 'package:auth/src/views/login_view.dart';
import 'package:auth/src/views/register_view.dart';
import 'package:core/core.dart';
import 'package:domain/usecases/export_usecases.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class StartAuthView extends StatelessWidget {
  const StartAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = navigationGetIt<AppRouter>();
    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(
        appLocator.get<RegisterUsecase>(),
        appLocator.get<LoginUsecase>(),
        appLocator.get<CheckUserAuthenticationUseCase>(),
        appRouter,
      )..add(InitAuthEvent()),
      child: const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
