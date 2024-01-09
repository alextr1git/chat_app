import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class ChatHomeView extends StatefulWidget {
  const ChatHomeView({super.key});

  @override
  State<ChatHomeView> createState() => _ChatHomeViewState();
}

class _ChatHomeViewState extends State<ChatHomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home page')),
    );
  }
}
