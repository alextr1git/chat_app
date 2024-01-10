part of 'auth_bloc.dart';

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

class LogoutUserEvent extends AuthEvent {}

class NavigateToHomeEvent extends AuthEvent {}

class NavigateToRegisterEvent extends AuthEvent {}

class NavigateToLoginInEvent extends AuthEvent {}

class SendVerificationEmailEvent extends AuthEvent {}
