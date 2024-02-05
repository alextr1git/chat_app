part of 'general_settings_bloc.dart';

@immutable
class GeneralSettingsState {
  final Locale currentLocale;

  GeneralSettingsState({required this.currentLocale});

  GeneralSettingsState copyWith({
    Locale? currentLocale,
  }) =>
      GeneralSettingsState(currentLocale: currentLocale ?? this.currentLocale);

  static GeneralSettingsState get init => GeneralSettingsState(
        currentLocale: Locale('en', 'US'),
      );
}
