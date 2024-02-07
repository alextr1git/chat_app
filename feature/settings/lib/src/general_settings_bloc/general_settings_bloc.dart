import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'general_settings_event.dart';
part 'general_settings_state.dart';

class GeneralSettingsBloc
    extends Bloc<GeneralSettingsEvent, GeneralSettingsState> {
  GeneralSettingsBloc() : super(GeneralSettingsState.init) {
    on<GeneralSettingsEvent>((event, emit) {});
  }
}
