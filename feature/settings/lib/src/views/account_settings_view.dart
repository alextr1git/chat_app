import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/src/account_settings_bloc/account_settings_bloc.dart';
import 'package:core/core.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  late final TextEditingController _nameController;
  late final UserModel userModel;

  @override
  void initState() {
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AccountSettingsBloc(appLocator.get<GetUserUseCase>())
            ..add(InitSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Account settings"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
            builder: (context, state) {
              return Column(children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Your email is:"),
                Text(
                  state.userModel.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      hintText: 'Enter your name',
                      labelText: "Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Save changes"))
              ]);
            },
          ),
        ),
      ),
    );
  }
}
