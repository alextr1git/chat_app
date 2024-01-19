class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final num timeStamp;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timeStamp,
    required this.chatId,
  });

  factory MessageEntity.fromJson(
          Map<Object?, Object?> json, String chatId, String messageId) =>
      MessageEntity(
        id: messageId ?? "",
        chatId: chatId ?? "",
        senderId: json['sender-id'].toString() ?? "",
        message: json['message'].toString() ?? "",
        timeStamp: json['timestamp'] as num ?? 0,
      );
}
