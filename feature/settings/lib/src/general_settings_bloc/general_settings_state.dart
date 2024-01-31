part of 'general_settings_bloc.dart';

@immutable
class GeneralSettingsState {
  final Locale currentLocale;

  const GeneralSettingsState({required this.currentLocale});

  GeneralSettingsState copyWith({
    Locale? currentLocale,
  }) =>
      GeneralSettingsState(currentLocale: currentLocale ?? this.currentLocale);

  static GeneralSettingsState get init => const GeneralSettingsState(
        currentLocale: Locale('en', 'US'),
      );
}
