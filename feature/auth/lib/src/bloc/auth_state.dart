part of 'auth_bloc.dart';

@immutable
class AuthState {
  final LoadingState loadingState;
  final UserModel userModel;

  const AuthState({
    required this.loadingState,
    required this.userModel,
  });

  AuthState copyWith({
    LoadingState? loadingState,
    UserModel? userModel,
  }) =>
      AuthState(
        loadingState: loadingState ?? this.loadingState,
        userModel: userModel ?? this.userModel,
      );

  static AuthState get init => AuthState(
        loadingState: LoadingState.init,
        userModel: UserModel.empty,
      );
}
