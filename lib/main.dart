import 'package:auth/auth.dart';
import 'package:core/bloc_providers/global_bloc_provider.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDI.initDependencies();
  await dataDI.initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appRouter = navigationGetIt<AppRouter>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProvider(
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
