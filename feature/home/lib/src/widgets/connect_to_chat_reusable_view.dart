import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../../home.dart';

class ConnectToChat extends StatefulWidget {
  final String _textFieldHint;
  final String _textFieldLabel;
  final String _buttonText;
  final bool _showColorPicker;
  final Function(String text) _onPressed;

  final Icon _icon;

  ConnectToChat({
    required String textFieldHint,
    required String textFieldLabel,
    required String buttonText,
    required Icon icon,
    required bool showColorPicker,
    required Function(String text) onPressed,
    super.key,
  })  : _textFieldHint = textFieldHint,
        _textFieldLabel = textFieldLabel,
        _buttonText = buttonText,
        _onPressed = onPressed,
        _icon = icon,
        _showColorPicker = showColorPicker;

  @override
  State<ConnectToChat> createState() => _ConnectToChatState();
}

class _ConnectToChatState extends State<ConnectToChat> {
  late Color selectedColor;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    selectedColor = Colors.blue;
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
          mainAxisAlignment: (widget._showColorPicker)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (widget._showColorPicker)
              ColorPickerWidget(
                onColorSelected: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
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
                // widget._onPressed(_textEditingController.text);
                print(selectedColor);
              },
              child: Text(widget._buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerWidget extends StatefulWidget {
  final void Function(Color color) onColorSelected;

  const ColorPickerWidget({super.key, required this.onColorSelected});

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  @override
  void initState() {
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Card(
                elevation: 2,
                child: ColorPicker(
                  pickersEnabled: <ColorPickerType, bool>{
                    ColorPickerType.accent: false,
                  },
                  enableShadesSelection: false,
                  // Use the screenPickerColor as start color.
                  color: screenPickerColor,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: (Color color) {
                    setState(() => screenPickerColor = color);
                    widget.onColorSelected(color);
                  },

                  width: 44,
                  height: 44,
                  borderRadius: 22,
                  heading: Text(
                    'Select color',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ColorIndicator(
            width: 500,
            height: 50,
            borderRadius: 22,
            color: screenPickerColor,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
