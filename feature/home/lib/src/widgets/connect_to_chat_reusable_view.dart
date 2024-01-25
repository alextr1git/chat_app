import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home.dart';

class ConnectToChat extends StatefulWidget {
  final String _textFieldHint;
  final String _textFieldLabel;
  final String _buttonText;
  final Function(String text) _onPressed;
  final Icon _icon;

  ConnectToChat({
    required String textFieldHint,
    required String textFieldLabel,
    required String buttonText,
    required Icon icon,
    required Function(String text) onPressed,
    super.key,
  })  : _textFieldHint = textFieldHint,
        _textFieldLabel = textFieldLabel,
        _buttonText = buttonText,
        _onPressed = onPressed,
        _icon = icon;

  @override
  State<ConnectToChat> createState() => _ConnectToChatState();
}

class _ConnectToChatState extends State<ConnectToChat> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: widget._textFieldHint,
                labelText: widget._textFieldLabel,
                prefixIcon: widget._icon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Visibility(
                    visible: state.error != null,
                    child: Text(
                      state.error ?? "",
                      style: TextStyle(
                        color: Colors.redAccent[400],
                      ),
                    ));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(64, 12, 64, 12))),
              onPressed: () {
                widget._onPressed(_textEditingController.text);
              },
              child: Text(widget._buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
