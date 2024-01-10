import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _switchLanguage() {
      if (EasyLocalization.of(context)!.currentLocale == Locale('ru', 'RU')) {
        return ['en', 'US'];
      } else {
        return ['ru', 'RU'];
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_view_title.tr())),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  List<String> newLocale = _switchLanguage();
                  EasyLocalization.of(context)!
                      .setLocale(Locale(newLocale[0], newLocale[1]));
                },
                child: Text(LocaleKeys.settings_switch_language_button.tr()))
          ],
        ),
      ),
    );
  }
}
