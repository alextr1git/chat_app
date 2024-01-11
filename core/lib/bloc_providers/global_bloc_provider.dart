import 'package:auth/auth.dart';
import 'package:settings/src/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:navigation/navigation.dart';

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;
  const GlobalBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: <BlocProvider>[
      BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
                appLocator.get<RegisterUsecase>(),
                appLocator.get<LoginUsecase>(),
                appLocator.get<CheckUserAuthenticationUseCase>(),
                appLocator.get<SendVerificationEmailUseCase>(),
                appLocator.get<LogoutUserUseCase>(),
                appLocator.get<SetUsernameUseCase>(),
                appLocator.get<SetUserPhotoURLUseCase>(),
                navigationGetIt.get<AppRouter>(),
              )),
    ], child: child);
  }
}
