import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  AppDI.initDependencies();
  await dataDI.initDependencies();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ru', 'RU'),
    ],
    fallbackLocale: Locale('en', 'US'),
    path: AppLocalization.langsFolderPath,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final appRouter = navigationGetIt<AppRouter>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: appRouter.config(),
      title: 'CHATSAPP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
