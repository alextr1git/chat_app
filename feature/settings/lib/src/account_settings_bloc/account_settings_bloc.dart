import 'dart:async';
import 'dart:io';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';

part 'account_settings_event.dart';
part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final GetUserUseCase _getUserUseCase;
  final SetUsernameUseCase _setUsernameUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final DownloadImageUseCase _downloadImageUseCase;

  AccountSettingsBloc(
      {required getUserUseCase,
      required setUsernameUseCase,
      required uploadImageUseCase,
      required downloadImageUseCase})
      : _getUserUseCase = getUserUseCase,
        _setUsernameUseCase = setUsernameUseCase,
        _uploadImageUseCase = uploadImageUseCase,
        _downloadImageUseCase = downloadImageUseCase,
        super(AccountSettingsState.init) {
    on<InitSettingsEvent>(_initSettings);
    on<UpdateNameAndImageEvent>(_updateNameAndImage);
  }

  _initSettings(
    InitSettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    String photoPath = '';

    final UserModel userModel = await _getUserUseCase.execute(NoParams());
    if (userModel.photoURL != null) {
      photoPath = await _downloadImageUseCase.execute(NoParams());
    }
    emit(
      state.copyWith(
        userModel: userModel,
        photoPath: photoPath,
      ),
    );
  }

  Future<void> _updateNameAndImage(
    UpdateNameAndImageEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    await _setUsernameUseCase.execute(event.userName);
    await _uploadImageUseCase.execute(event.image);
    await _downloadImageUseCase.execute(NoParams());
  }
}
