import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:home/src/views/add_chat_view.dart';
import 'package:home/src/views/personal_chat_view.dart';
import 'package:navigation/navigation.dart';
import 'package:settings/settings.dart';

@RoutePage()
class SharedNavbarView extends StatefulWidget {
  const SharedNavbarView({super.key});

  @override
  State<SharedNavbarView> createState() => _SharedNavbarViewState();
}

class _SharedNavbarViewState extends State<SharedNavbarView> {
  int selectedView = 1;

  final List<Widget> _views = const [
    AccountSettingsView(),
    AddChatView(),
    /*ChatHomeView(),*/
    SettingsView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _views[selectedView],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedView,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: LocaleKeys.navbar_account.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_sharp),
              label: LocaleKeys.navbar_chats.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: LocaleKeys.navbar_settings.tr(),
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
