part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  final UserModel userModel;

  const AccountSettingsState({required this.userModel});

  AccountSettingsState copyWith({
    UserModel? userModel,
  }) =>
      AccountSettingsState(userModel: userModel ?? this.userModel);

  static AccountSettingsState get init => AccountSettingsState(
        userModel: UserModel.empty,
      );
}
