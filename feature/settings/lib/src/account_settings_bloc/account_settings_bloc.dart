import 'dart:async';
import 'dart:io';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:navigation/navigation.dart';
part 'account_settings_event.dart';
part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final GetUserUseCase _getUserUseCase;
  final SetUsernameUseCase _setUsernameUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final DownloadImageUseCase _downloadImageUseCase;
  final GetUsernameByIDUseCase _getUsernameByIDUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final AppRouter _router;

  AccountSettingsBloc({
    required getUserUseCase,
    required setUsernameUseCase,
    required uploadImageUseCase,
    required downloadImageUseCase,
    required getUsernameByIDUseCase,
    required logoutUserUseCase,
    required router,
  })  : _getUserUseCase = getUserUseCase,
        _setUsernameUseCase = setUsernameUseCase,
        _uploadImageUseCase = uploadImageUseCase,
        _downloadImageUseCase = downloadImageUseCase,
        _getUsernameByIDUseCase = getUsernameByIDUseCase,
        _logoutUserUseCase = logoutUserUseCase,
        _router = router,
        super(AccountSettingsState.init) {
    on<InitSettingsEvent>(_initSettings);
    on<UpdateNameAndImageEvent>(_updateNameAndImage);
    on<LogoutUserEvent>(_logoutUser);
  }

  _initSettings(
    InitSettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    String photoPath = '';

    final UserModel? userModel =
        await _getUserUseCase.execute(const NoParams());
    if (userModel != null) {
      if (userModel.photoURL.isNotEmpty) {
        photoPath = await _downloadImageUseCase.execute(const NoParams());
      }
      final String username =
          await _getUsernameByIDUseCase.execute(userModel.id);
      emit(
        state.copyWith(
          userModel: userModel,
          photoPath: photoPath,
          username: username,
        ),
      );
    }
  }

  Future<void> _updateNameAndImage(
    UpdateNameAndImageEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    await _setUsernameUseCase.execute(event.userName);
    await _uploadImageUseCase.execute(event.image);
    await _downloadImageUseCase.execute(const NoParams());
  }

  Future<void> _logoutUser(
    _,
    Emitter<AccountSettingsState> emit,
  ) async {
    _logoutUserUseCase.execute(const NoParams());
    _router.replace(const LoginRoute());
  }
}
