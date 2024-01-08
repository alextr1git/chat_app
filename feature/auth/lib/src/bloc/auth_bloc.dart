import 'dart:async';
import 'package:auth/src/navigation/router.dart';
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
        emit(
          state.copyWith(
            isLoaded: true,
            userModel: userModel,
            authView: AuthView.home,
          ),
        );
        _router.replace(const LoginRoute()); //TODO add real home-route
      } else {
        emit(
          state.copyWith(
            authView: AuthView.register,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          viewState: FailureViewState(
            exceptionMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _register(
    RegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    String exceptionMessage = '';
    try {
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
      final UserModel userModel = await _registerUseCase.execute(
        {
          'email': event.email,
          'password': event.password,
        },
      );
      emit(
        state.copyWith(
          isLoaded: true,
          userModel: userModel,
          viewState: NeedVerificationState(),
          isLoading: false,
          authView: AuthView.verify, //TODO add real verify route
        ),
      );

      // _router.replace(const VerifyEmailRoute()); //TODO add real route
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
          isLoading: false,
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
      emit(state.copyWith(isLoading: true));
      final UserModel userModel = await _loginUseCase.execute(
        {
          'email': event.email,
          'password': event.password,
        },
      );
      emit(
        state.copyWith(
          isLoaded: true,
          userModel: userModel,
          viewState: NeedVerificationState(),
          isLoading: false,
          authView: AuthView.home,
        ),
      );

      _router.replace(const RegisterRoute()); //TODO add real route
    } on Exception catch (e) {
      if (e is InvalidCredentialsAuthException) {
        exceptionMessage = "Credentials are invalid";
      } else if (e is GenericAuthException) {
        exceptionMessage = "Generic error occurred";
      }
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
      _router.push(FailurePopupRoute(exceptionMessage: exceptionMessage));
    }
  }

  Future<void> _navigateToRegisterView(
    _,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authView: AuthView.register,
      ),
    );
  }

  Future<void> _navigateToLoginView(
    _,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authView: AuthView.login,
      ),
    );
  }
}

// //generic exceptions
//     class NetworkRequestFailedAuthException implements Exception {}
//
//     class GenericAuthException implements Exception {}
//
//     class UserNotLoggedInAuthException implements Exception {}
