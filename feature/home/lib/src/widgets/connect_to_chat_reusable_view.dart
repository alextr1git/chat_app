import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../../home.dart';

class ConnectToChat extends StatefulWidget {
  final String _textFieldHint;
  final String _textFieldLabel;
  final String _buttonText;
  final bool _showColorPicker;
  final Function(String text, int? color) _onPressed;

  final Icon _icon;

  const ConnectToChat({
    required String textFieldHint,
    required String textFieldLabel,
    required String buttonText,
    required Icon icon,
    required bool showColorPicker,
    required Function(String text, int? color) onPressed,
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: (widget._showColorPicker)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
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
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatsErrorState) {
                    return Text(
                      state.error ?? "",
                      style: TextStyle(
                        color: Colors.redAccent[400],
                      ),
                    );
                  } else {
                    return const Text("");
                  }
                },
              ),
              if (widget._showColorPicker)
                ColorPickerWidget(
                  onColorSelected: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(64, 12, 64, 12))),
                onPressed: () {
                  widget._onPressed(
                      _textEditingController.text, selectedColor.value);
                },
                child: Text(widget._buttonText),
              ),
            ],
          ),
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
    return Column(
      children: [
        ColorIndicator(
          width: 500,
          height: 50,
          borderRadius: 22,
          color: screenPickerColor,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Card(
              elevation: 2,
              child: ColorPicker(
                pickersEnabled: const <ColorPickerType, bool>{
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
                  LocaleKeys.add_chat_view_select_color.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
