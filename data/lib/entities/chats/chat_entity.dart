class ChatEntity {
  final String id;
  final String title;
  final String lastMessageId;
  final num timestamp;
  final int messageCount;

  ChatEntity({
    required this.id,
    required this.title,
    required this.lastMessageId,
    required this.timestamp,
    required this.messageCount,
  });

  factory ChatEntity.fromJson(Map<Object?, Object?> json, String chatId) =>
      ChatEntity(
        id: chatId ?? "",
        title: json['title'] as String ?? "",
        lastMessageId: json['last-message-id'] as String ?? "",
        timestamp: json['timestamp'] as num ?? 0,
        messageCount: json['message-count'] as int ?? 0,
      );
}
