part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsEvent {}

class InitSettingsEvent extends AccountSettingsEvent {}

class UpdateNameAndImageEvent extends AccountSettingsEvent {
  final String userName;
  final File? image;

  UpdateNameAndImageEvent({
    required this.userName,
    required this.image,
  });
}

class LogoutUserEvent extends AccountSettingsEvent {}
