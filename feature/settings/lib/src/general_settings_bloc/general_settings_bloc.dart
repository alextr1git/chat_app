import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'general_settings_event.dart';
part 'general_settings_state.dart';

class GeneralSettingsBloc
    extends Bloc<GeneralSettingsEvent, GeneralSettingsState> {
  GeneralSettingsBloc() : super(GeneralSettingsInitial()) {
    on<GeneralSettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
