import 'dart:async';

import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:domain/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:domain/domain.dart';

part 'account_settings_event.dart';
part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final GetUserUseCase _getUserUseCase;
  final SetUsernameUseCase _setUsernameUseCase;

  AccountSettingsBloc(this._getUserUseCase, this._setUsernameUseCase)
      : super(AccountSettingsState.init) {
    on<InitSettingsEvent>(_initSettings);
    on<SetNewUsernameEvent>(_setUsername);
  }

  _initSettings(
    InitSettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    final UserModel userModel = await _getUserUseCase.execute(NoParams());
    emit(
      state.copyWith(
        userModel: userModel,
      ),
    );
  }

  Future<void> _setUsername(
    SetNewUsernameEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    await _setUsernameUseCase.execute(event.userName);
  }
}
