import 'package:core/core.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

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
