import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  Future<void> _navigateToRegisterPage(
    _,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authScreen: AuthScreen.signIn,
      ),
    );
  }
}
