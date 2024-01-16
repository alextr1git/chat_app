class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final num timeStamp;

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.timeStamp,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
        id: json['id'] ?? "",
        chatId: json['chatId'] ?? "",
        senderId: json['senderId'] ?? "",
        message: json['message'] ?? "",
        timeStamp: json['timeStamp'] ?? 0,
      );
}
