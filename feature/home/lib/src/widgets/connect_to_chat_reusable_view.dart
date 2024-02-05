import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home.dart';

class ConnectToChat extends StatefulWidget {
  final String _textFieldHint;
  final String _textFieldLabel;
  final String _buttonText;
  final bool _showColorPicker;
  final bool _isCreateChatView;
  final Function(String text, int? color) _onPressed;

  final Icon _icon;

  const ConnectToChat({
    required String textFieldHint,
    required String textFieldLabel,
    required String buttonText,
    required bool isCreateChatView,
    required Icon icon,
    required bool showColorPicker,
    required Function(String text, int? color) onPressed,
    super.key,
  })  : _textFieldHint = textFieldHint,
        _textFieldLabel = textFieldLabel,
        _buttonText = buttonText,
        _onPressed = onPressed,
        _icon = icon,
        _showColorPicker = showColorPicker,
        _isCreateChatView = isCreateChatView;

  @override
  State<ConnectToChat> createState() => _ConnectToChatState();
}

class _ConnectToChatState extends State<ConnectToChat> {
  late Color selectedColor;
  late final TextEditingController _textEditingController;
  String errorMessage = '';

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
    SingleChatBloc singleChatBloc = BlocProvider.of<SingleChatBloc>(context);

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
                onTap: () => setState(() {
                  errorMessage = '';
                }),
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
              BlocListener<SingleChatBloc, SingleChatState>(
                listener: (context, state) {
                  if (singleChatBloc.state is ChatsSingleChatDataErrorState) {
                    setState(() {
                      errorMessage = (singleChatBloc.state
                              as ChatsSingleChatDataErrorState)
                          .errorMessage;
                    });
                  }
                },
                child: const SizedBox(),
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage.isNotEmpty
                      ? errorMessage
                      : (singleChatBloc.state as ChatsSingleChatDataErrorState)
                          .errorMessage,
                  style: TextStyle(
                    color: Colors.redAccent[400],
                  ),
                ),
              const SizedBox(height: 10),
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
                  bool createChatCondition =
                      _textEditingController.text.length >= 5 &&
                          _textEditingController.text.length <= 20;
                  bool connectToChatCondition =
                      _textEditingController.text.length == 20;
                  bool condition = (widget._isCreateChatView)
                      ? createChatCondition
                      : connectToChatCondition;
                  if (condition) {
                    widget._onPressed(
                        _textEditingController.text, selectedColor.value);
                  } else {
                    setState(() {
                      errorMessage = widget._isCreateChatView
                          ? LocaleKeys.add_chat_view_name_error_message.tr()
                          : LocaleKeys.add_chat_view_invalid_link_error_message
                              .tr();
                    });
                  }
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
