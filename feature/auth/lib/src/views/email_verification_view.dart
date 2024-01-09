import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text("Email verification page")),
      ),
    );
  }
}
