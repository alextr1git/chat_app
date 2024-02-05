part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  final UserModel userModel;
  final String photoPath;

  const AccountSettingsState({
    required this.userModel,
    required this.photoPath,
  });

  AccountSettingsState copyWith({
    UserModel? userModel,
    String? photoPath,
  }) =>
      AccountSettingsState(
        userModel: userModel ?? this.userModel,
        photoPath: photoPath ?? this.photoPath,
      );

  static AccountSettingsState get init => AccountSettingsState(
        userModel: UserModel.empty,
        photoPath: '',
      );
}
