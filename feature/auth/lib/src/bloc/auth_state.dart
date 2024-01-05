part of 'auth_bloc.dart';

@immutable
class AuthState {
  final bool isLoaded;
  final UserModel userModel;
  final bool isLoading;
  final AuthView authView;

  AuthState({
    required this.isLoaded,
    required this.userModel,
    required this.isLoading,
    required this.authView,
  });

  AuthState copyWith({
    bool? isLoaded,
    UserModel? userModel,
    bool? isLoading,
    AuthView? authView,
  }) =>
      AuthState(
        isLoaded: isLoaded ?? this.isLoaded,
        userModel: userModel ?? this.userModel,
        isLoading: isLoading ?? this.isLoading,
        authView: authView ?? this.authView,
      );
}
