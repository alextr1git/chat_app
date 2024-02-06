import 'dart:io';
import 'package:auth/auth.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:settings/settings.dart';
import 'package:core/core.dart';

class AccountSettingsContent extends StatefulWidget {
  final ImageHelper imageHelper;
  const AccountSettingsContent({
    super.key,
    required this.imageHelper,
  });

  @override
  State<AccountSettingsContent> createState() => _AccountSettingsContentState();
}

class _AccountSettingsContentState extends State<AccountSettingsContent> {
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
    AccountSettingsBloc accountSettingsBloc =
        BlocProvider.of<AccountSettingsBloc>(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(LocaleKeys.account_settings_title.tr()),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    accountSettingsBloc.add(LogoutUserEvent());
                  } else {}
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(LocaleKeys.account_settings_logout.tr()),
                ),
              ];
            })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
              builder: (context, state) {
                final AccountSettingsBloc accountSettingsBloc =
                    BlocProvider.of<AccountSettingsBloc>(context);

                if (state.username != '') {
                  _nameController.text = state.username;
                }

                return Column(children: [
                  Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 64,
                        foregroundImage: _image != null
                            ? FileImage(_image!)
                            : (state.photoPath != ''
                                ? FileImage(File(state.photoPath))
                                : null),
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
                      final file = await widget.imageHelper.pickImage();
                      if (file != null) {
                        final croppedFile = await widget.imageHelper.crop(
                          file: file,
                          cropStyle: CropStyle.circle,
                        );
                        if (croppedFile != null) {
                          setState(() {
                            _image = File(croppedFile.path);
                          });
                        }
                      }
                    },
                    child: Text(LocaleKeys.account_settings_select_photo.tr()),
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
                        hintText:
                            LocaleKeys.account_settings_name_form_hint.tr(),
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
                        if (_nameController.text.length >= 3 &&
                            _nameController.text.length <= 20) {
                          accountSettingsBloc.add(UpdateNameAndImageEvent(
                            userName: _nameController.text,
                            image: _image,
                          ));
                          SnackBar snackBar = SnackBar(
                            content: Text(LocaleKeys
                                .account_settings_changes_applied
                                .tr()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          SnackBar snackBar = SnackBar(
                            content: Text(LocaleKeys
                                .account_settings_changes_cant_be_applied
                                .tr()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child:
                          Text(LocaleKeys.account_settings_save_changes.tr())),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
