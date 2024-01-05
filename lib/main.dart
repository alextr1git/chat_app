import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupNavigationDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appRouter = navigationGetIt<AppRouter>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(),
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
