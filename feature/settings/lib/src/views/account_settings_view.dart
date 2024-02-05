import 'package:auth/auth.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/settings.dart';
import 'package:core/core.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AccountSettingsBloc(
              getUserUseCase: appLocator.get<GetUserUseCase>(),
              setUsernameUseCase: appLocator.get<SetUsernameUseCase>(),
              uploadImageUseCase: appLocator.get<UploadImageUseCase>(),
              downloadImageUseCase: appLocator.get<DownloadImageUseCase>(),
              getUsernameByIDUseCase: appLocator.get<GetUsernameByIDUseCase>(),
            )..add(InitSettingsEvent()),
        child: AccountSettingsContent(
          authBloc: BlocProvider.of<AuthBloc>(context),
          imageHelper: appLocator.get<ImageHelper>(),
        ));
  }
}
