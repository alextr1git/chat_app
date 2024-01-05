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
    on<LoginInEvent>(_navigateToLoginView);
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
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          viewState: FailureViewState(
            error: error.message,
          ),
        ),
      );
    }
  }

  Future<void> _register(
    RegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
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
          viewState: SuccessViewState(),
          isLoading: false,
          authView: AuthView.home,
        ),
      );

      _router.replace(const LoginRoute()); //TODO add real route
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          viewState: FailureViewState(error: error.message),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _login(
    LoginInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
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
          viewState: SuccessViewState(),
          isLoading: false,
          authView: AuthView.home,
        ),
      );

      _router.replace(const RegisterRoute()); //TODO add real route
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          viewState: FailureViewState(error: error.message),
          isLoading: false,
        ),
      );
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
