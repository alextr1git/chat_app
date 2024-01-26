class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final int timeStamp;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timeStamp,
    required this.chatId,
  });
  static MessageEntity get empty {
    return MessageEntity(
      id: '',
      chatId: '',
      senderId: '',
      message: '',
      timeStamp: 0,
    );
  }

  factory MessageEntity.fromJson(
          Map<Object?, Object?> json, String chatId, String messageId) =>
      MessageEntity(
        id: messageId ?? "",
        chatId: chatId ?? "",
        senderId: json['sender-id'].toString() ?? "",
        message: json['message'].toString() ?? "",
        timeStamp: json['timestamp'] as int ?? 0,
      );
}
