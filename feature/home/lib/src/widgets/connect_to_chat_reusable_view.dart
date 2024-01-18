import 'package:flutter/material.dart';

class ConnectToChat extends StatelessWidget {
  final String _textFieldHint;
  final String _textFieldLabel;
  final String _buttonText;
  final Function() _onPressed;
  final Icon _icon;
  const ConnectToChat({
    required String textFieldHint,
    required String textFieldLabel,
    required String buttonText,
    required Icon icon,
    required Function() onPressed,
    super.key,
  })  : _textFieldHint = textFieldHint,
        _textFieldLabel = textFieldLabel,
        _buttonText = buttonText,
        _onPressed = onPressed,
        _icon = icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: _textFieldHint,
                labelText: _textFieldLabel,
                prefixIcon: _icon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(64, 12, 64, 12))),
              onPressed: () {
                _onPressed();
              },
              child: Text(_buttonText),
            )
          ],
        ),
      ),
    );
  }
}
