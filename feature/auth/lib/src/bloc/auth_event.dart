part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitAuthEvent extends AuthEvent {}

class RegistrationEvent extends AuthEvent {
  final String email;
  final String password;

  RegistrationEvent({
    required this.email,
    required this.password,
  });
}

class LoginInEvent extends AuthEvent {
  final String email;
  final String password;

  LoginInEvent({
    required this.email,
    required this.password,
  });
}

class NavigateToRegisterEvent extends AuthEvent {}

class NavigateToLoginInEvent extends AuthEvent {}
