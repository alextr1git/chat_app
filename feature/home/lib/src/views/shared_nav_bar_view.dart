import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';
import 'package:settings/src/settings.dart';

@RoutePage()
class SharedNavbarView extends StatefulWidget {
  const SharedNavbarView({super.key});

  @override
  State<SharedNavbarView> createState() => _SharedNavbarViewState();
}

class _SharedNavbarViewState extends State<SharedNavbarView> {
  int selectedView = 0;

  final List<Widget> _views = const [
    AccountSettingsView(),
    ChatHomeView(),
    SettingsView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _views[selectedView],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedView,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_sharp),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedView = index;
            });
          },
        ));
  }
}
