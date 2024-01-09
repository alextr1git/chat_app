import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:domain/usecases/auth_usecases/check_user_auth_usecase.dart';
import 'package:domain/usecases/auth_usecases/login_usecase.dart';
import 'package:domain/usecases/auth_usecases/register_usecase.dart';
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
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
