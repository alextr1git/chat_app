import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    const double languageFlagsSize = 50;
    const Locale russianLocale = Locale("ru", 'RU');
    const Locale englishLocale = Locale("en", 'US');

    void _setRussianLocale() async {
      await EasyLocalization.of(context)!.setLocale(russianLocale);
    }

    void _setEnglishLocale() async {
      await EasyLocalization.of(context)!.setLocale(englishLocale);
    }

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_view_title.tr())),
      body: Center(
        child: Column(
          children: [
            Text(LocaleKeys.settings_choose_language_text.tr()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _setEnglishLocale,
                  child: Image.asset(
                    'core_ui/assets/images/eng_flag.png',
                    height: languageFlagsSize,
                    width: languageFlagsSize,
                  ),
                ),
                TextButton(
                    onPressed: _setRussianLocale,
                    child: Image.asset(
                      'core_ui/assets/images/rus_flag.png',
                      height: languageFlagsSize,
                      width: languageFlagsSize,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
