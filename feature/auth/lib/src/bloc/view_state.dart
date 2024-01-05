part of 'auth_bloc.dart';

abstract class ViewState {}

class InitViewState extends ViewState {}

class SuccessViewState extends ViewState {}

class FailureViewState extends ViewState {
  final String? error;

  FailureViewState({required this.error});

  @override
  String toString() => error ?? '';
}
