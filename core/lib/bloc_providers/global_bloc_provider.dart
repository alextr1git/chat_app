import 'package:auth/auth.dart';
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
                registerUseCase: appLocator.get<RegisterUsecase>(),
                loginUseCase: appLocator.get<LoginUseCase>(),
                checkUserAuthenticationUseCase:
                    appLocator.get<CheckUserAuthenticationUseCase>(),
                sendVerificationEmailUseCase:
                    appLocator.get<SendVerificationEmailUseCase>(),
                logoutUserUseCase: appLocator.get<LogoutUserUseCase>(),
                setUsernameUseCase: appLocator.get<SetUsernameUseCase>(),
                setUserPhotoURLUseCase:
                    appLocator.get<SetUserPhotoURLUseCase>(),
                router: navigationGetIt.get<AppRouter>(),
              )),
    ], child: child);
  }
}
