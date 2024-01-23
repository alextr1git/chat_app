part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  final UserModel userModel;
  final String username;
  final String photoPath;

  const AccountSettingsState({
    required this.userModel,
    required this.photoPath,
    required this.username,
  });

  AccountSettingsState copyWith({
    UserModel? userModel,
    String? photoPath,
    String? username,
  }) =>
      AccountSettingsState(
        userModel: userModel ?? this.userModel,
        photoPath: photoPath ?? this.photoPath,
        username: username ?? this.username,
      );

  static AccountSettingsState get init => AccountSettingsState(
        userModel: UserModel.empty,
        photoPath: '',
        username: '',
      );
}
