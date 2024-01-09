import 'dart:async';
import 'package:auth/src/navigation/router.dart';
import 'package:home/src/navigation/router.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/export_usecases.dart';
import 'package:domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:data/data.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'view_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckUserAuthenticationUseCase _checkUserAuthenticationUseCase;
  final RegisterUsecase _registerUseCase;
  final LoginUsecase _loginUseCase;
  final AppRouter _router;

  AuthBloc(
    this._registerUseCase,
    this._loginUseCase,
    this._checkUserAuthenticationUseCase,
    this._router,
  ) : super(AuthState.init) {
    on<InitAuthEvent>(_initAuth);
    on<RegistrationEvent>(_register);
    on<LoginInEvent>(_login);
    on<NavigateToRegisterEvent>(_navigateToRegisterView);
    on<NavigateToLoginInEvent>(_navigateToLoginView);
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
        _router.push(const ChatHomeRoute());
      } else {
        _router.push(const LoginRoute());
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
        _router.push(const ChatHomeRoute());
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

  Future<void> _navigateToRegisterView(
    _,
    Emitter<AuthState> emit,
  ) async {
    _router.push(const RegisterRoute());
  }

  Future<void> _navigateToLoginView(
    _,
    Emitter<AuthState> emit,
  ) async {
    _router.push(const LoginRoute());
  }
}

// //generic exceptions
//     class NetworkRequestFailedAuthException implements Exception {}
//
//     class GenericAuthException implements Exception {}
//
//     class UserNotLoggedInAuthException implements Exception {}
