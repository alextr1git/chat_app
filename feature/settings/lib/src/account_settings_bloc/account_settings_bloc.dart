import 'dart:async';
import 'dart:io';

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
  final UploadImageUseCase _uploadImageUseCase;

  AccountSettingsBloc(
      this._getUserUseCase, this._setUsernameUseCase, this._uploadImageUseCase)
      : super(AccountSettingsState.init) {
    on<InitSettingsEvent>(_initSettings);
    on<UpdateNameAndImageEvent>(_updateNameAndImage);
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

  Future<void> _updateNameAndImage(
    UpdateNameAndImageEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    //await _setUsernameUseCase.execute(event.userName);
    await _uploadImageUseCase.execute(event.image);
  }
}

/*

*/
