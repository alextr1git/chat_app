import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:settings/settings.dart';
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
  File? _image;

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
    final ImageHelper imageHelper = appLocator.get<ImageHelper>();
    return BlocProvider(
      create: (BuildContext context) => AccountSettingsBloc(
        appLocator.get<GetUserUseCase>(),
        appLocator.get<SetUsernameUseCase>(),
      )..add(InitSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.account_settings_account_settings_title.tr()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
            builder: (context, state) {
              final AccountSettingsBloc accountSettingsBloc =
                  BlocProvider.of<AccountSettingsBloc>(context);

              if (state.userModel.userName != '') {
                _nameController.text = state.userModel.userName;
              }

              return Column(children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 64,
                      foregroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: const Text(
                        "AD",
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    final file = await imageHelper.pickImage();
                    if (file != null) {
                      final croppedFile = await imageHelper.crop(
                        file: file,
                        cropStyle: CropStyle.circle,
                      );
                      if (croppedFile != null) {
                        setState(() => _image = File(croppedFile.path));
                      }
                    }
                  },
                  child: const Text("Select photo"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(LocaleKeys.account_settings_your_email_is.tr()),
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
                      hintText: LocaleKeys.account_settings_name_form_hint.tr(),
                      labelText:
                          LocaleKeys.account_settings_name_form_label.tr(),
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
                    onPressed: () {
                      accountSettingsBloc.add(
                          SetNewUsernameEvent(userName: _nameController.text));
                    },
                    child: Text(LocaleKeys.account_settings_save_changes.tr()))
              ]);
            },
          ),
        ),
      ),
    );
  }
}
