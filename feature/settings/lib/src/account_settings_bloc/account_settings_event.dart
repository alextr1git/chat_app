part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsEvent {}

class InitSettingsEvent extends AccountSettingsEvent {}

class SetNewUsernameEvent extends AccountSettingsEvent {
  final String userName;

  SetNewUsernameEvent({required this.userName});
}
