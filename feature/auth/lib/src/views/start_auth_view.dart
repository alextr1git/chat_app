import 'package:auth/auth.dart';
import 'package:auth/src/views/email_verification_view.dart';
import 'package:auth/src/views/login_view.dart';
import 'package:auth/src/views/register_view.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/export_usecases.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class StartAuthView extends StatefulWidget {
  const StartAuthView({super.key});

  @override
  State<StartAuthView> createState() => _StartAuthViewState();
}

class _StartAuthViewState extends State<StartAuthView> {
  @override
  void initState() {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(InitAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
