import 'dart:async';
import 'package:auth/src/navigation/router.dart';
import 'package:home/src/navigation/router.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';
import 'package:data/data.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckUserAuthenticationUseCase _checkUserAuthenticationUseCase;
  final RegisterUsecase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final SendVerificationEmailUseCase _sendVerificationEmailUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final SetUsernameUseCase _setUsernameUseCase;
  final SetUserPhotoURLUseCase _setUserPhotoURLUseCase;
  final AppRouter _router;

  AuthBloc({
    required registerUseCase,
    required loginUseCase,
    required checkUserAuthenticationUseCase,
    required sendVerificationEmailUseCase,
    required logoutUserUseCase,
    required setUsernameUseCase,
    required setUserPhotoURLUseCase,
    required router,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _checkUserAuthenticationUseCase = checkUserAuthenticationUseCase,
        _sendVerificationEmailUseCase = sendVerificationEmailUseCase,
        _logoutUserUseCase = logoutUserUseCase,
        _setUsernameUseCase = setUsernameUseCase,
        _setUserPhotoURLUseCase = setUserPhotoURLUseCase,
        _router = router,
        super(AuthState.init) {
    on<InitAuthEvent>(_initAuth);
    on<RegistrationEvent>(_register);
    on<LoginInEvent>(_login);
    on<NavigateToRegisterEvent>(_navigateToRegisterView);
    on<NavigateToLoginInEvent>(_navigateToLoginView);
    on<SendVerificationEmailEvent>(_sendVerificationEmail);
    on<LogoutUserEvent>(_logoutUser);
    on<SetUsernameEvent>(_setUsername);
    on<SetUserPhotoURLEvent>(_setPhotoURL);
  }

  Future<void> _initAuth(
    InitAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final UserModel userModel = await _checkUserAuthenticationUseCase.execute(
        const NoParams(),
      );
      if (userModel != UserModel.empty) {
        if (userModel.isEmailVerified == true) {
          _router.replace(const SharedNavbarRoute());
        } else {
          _router.replace(const LoginRoute());
        }
      }
    } on Exception catch (e) {
      _router.push(FailurePopupRoute(exceptionMessage: e.toString()));
    }
  }

  Future<void> _register(
    RegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    String exceptionMessage = '';
    try {
      emit(state.copyWith(
        loadingState: LoadingState.loading,
      ));
      final UserModel userModel = await _registerUseCase.execute(
        {
          'email': event.email,
          'password': event.password,
        },
      );
      _sendVerificationEmail(event, emit);
      emit(
        state.copyWith(
          loadingState: LoadingState.loaded,
          userModel: userModel,
        ),
      );
      _router.push(const EmailVerificationRoute());
    } on Exception catch (e) {
      if (e is WeakPasswordAuthException) {
        exceptionMessage = "Your password is weak";
      } else if (e is EmailAlreadyInUseAuthException) {
        exceptionMessage = "Your email is already in use";
      } else if (e is InvalidEmailAuthException) {
        exceptionMessage = "Email is invalid";
      } else if (e is GenericAuthException) {
        exceptionMessage = "Generic error occurred";
      }
      emit(
        state.copyWith(
          loadingState: LoadingState.failure,
        ),
      );
      _router.push(FailurePopupRoute(exceptionMessage: exceptionMessage));
    }
  }

  Future<void> _login(
    LoginInEvent event,
    Emitter<AuthState> emit,
  ) async {
    String exceptionMessage = '';
    try {
      emit(state.copyWith(
        loadingState: LoadingState.loading,
      ));
      final UserModel userModel = await _loginUseCase.execute(
        {
          'email': event.email,
          'password': event.password,
        },
      );
      if (userModel.isEmailVerified == false) {
        emit(state.copyWith(
          loadingState: LoadingState.loaded,
          userModel: userModel,
        ));
        _router.push(const EmailVerificationRoute());
      } else {
        emit(state.copyWith(
          loadingState: LoadingState.loaded,
          userModel: userModel,
        ));
        _router.replace(const SharedNavbarRoute());
      }
    } on Exception catch (e) {
      if (e is InvalidCredentialsAuthException) {
        exceptionMessage = "Credentials are invalid";
      } else if (e is GenericAuthException) {
        exceptionMessage = "Generic error occurred";
      }
      emit(
        state.copyWith(
          loadingState: LoadingState.failure,
        ),
      );
      _router.push(FailurePopupRoute(exceptionMessage: exceptionMessage));
    }
  }

  Future<void> _logoutUser(
    _,
    Emitter<AuthState> emit,
  ) async {
    _logoutUserUseCase.execute(NoParams());
    _router.replace(const LoginRoute());
  }

  Future<void> _navigateToRegisterView(
    _,
    Emitter<AuthState> emit,
  ) async {
    _router.replace(const RegisterRoute());
  }

  Future<void> _navigateToLoginView(
    _,
    Emitter<AuthState> emit,
  ) async {
    _router.replace(const LoginRoute());
  }

  Future<void> _sendVerificationEmail(
    _,
    Emitter<AuthState> emit,
  ) async {
    await _sendVerificationEmailUseCase.execute(NoParams());
  }

  Future<void> _setUsername(
    SetUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _setUsernameUseCase.execute(event.userName);
  }

  Future<void> _setPhotoURL(
    SetUserPhotoURLEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _setUserPhotoURLUseCase.execute(event.userPhotoURL);
  }
}

// //generic exceptions
//     class NetworkRequestFailedAuthException implements Exception {}
//
//     class GenericAuthException implements Exception {}
//
//     class UserNotLoggedInAuthException implements Exception {}
