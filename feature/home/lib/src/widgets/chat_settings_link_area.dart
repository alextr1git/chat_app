import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatSettingsLinkArea extends StatelessWidget {
  final ChatModel chatModel;
  const ChatSettingsLinkArea({
    super.key,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.chat_settings_view_inviting_link.tr(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: chatModel.id))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(LocaleKeys
                              .chat_settings_view_copied_to_clipboard
                              .tr())));
                    });
                  },
                  child: const Icon(
                    Icons.link,
                    size: 40,
                  ),
                ),
                Text(
                  chatModel.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
