part of 'auth_bloc.dart';

@immutable
class AuthState {
  final bool isLoaded;
  final UserModel userModel;
  final bool isLoading;
  final AuthView authView;
  final ViewState viewState;

  const AuthState({
    required this.isLoaded,
    required this.userModel,
    required this.isLoading,
    required this.authView,
    required this.viewState,
  });

  AuthState copyWith({
    bool? isLoaded,
    UserModel? userModel,
    bool? isLoading,
    AuthView? authView,
    ViewState? viewState,
  }) =>
      AuthState(
        isLoaded: isLoaded ?? this.isLoaded,
        userModel: userModel ?? this.userModel,
        isLoading: isLoading ?? this.isLoading,
        authView: authView ?? this.authView,
        viewState: viewState ?? this.viewState,
      );

  static AuthState get init => AuthState(
        isLoaded: false,
        userModel: UserModel.empty,
        isLoading: false,
        authView: AuthView.home,
        viewState: InitViewState(),
      );
}
