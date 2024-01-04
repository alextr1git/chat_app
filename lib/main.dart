import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

void main() {
  setupNavigationDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appRouter = navigationGetIt<AppRouter>();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
