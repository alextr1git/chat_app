import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class AuthWrapperView extends StatelessWidget {
  const AuthWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      builder: (BuildContext context, Widget? child) {
        return BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            registerUseCase: appLocator.get<RegisterUsecase>(),
            loginUseCase: appLocator.get<LoginUseCase>(),
            checkUserAuthenticationUseCase:
                appLocator.get<CheckUserAuthenticationUseCase>(),
            sendVerificationEmailUseCase:
                appLocator.get<SendVerificationEmailUseCase>(),
            setUsernameUseCase: appLocator.get<SetUsernameUseCase>(),
            setUserPhotoURLUseCase: appLocator.get<SetUserPhotoURLUseCase>(),
            router: navigationGetIt.get<AppRouter>(),
          ),
          child: child,
        );
      },
    );
  }
}
