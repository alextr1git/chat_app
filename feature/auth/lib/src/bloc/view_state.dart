part of 'auth_bloc.dart';

abstract class ViewState {}

class InitViewState extends ViewState {}

class AuthorizedState extends ViewState {}

class NeedVerificationState extends ViewState {}

class FailureViewState extends ViewState {
  final String? exceptionMessage;

  FailureViewState({required this.exceptionMessage});

  @override
  String toString() => exceptionMessage ?? '';
}
