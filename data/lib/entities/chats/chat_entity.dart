class ChatEntity {
  final String id;
  final String title;
  final String lastMessage;
  final num timestamp;
  final int messageCount;

  ChatEntity({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    required this.messageCount,
  });

  factory ChatEntity.fromJson(Map<String, dynamic> json) => ChatEntity(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        lastMessage: json['lastMessage'] ?? "",
        timestamp: json['timestamp'] ?? 0,
        messageCount: json['messageCount'] ?? 0,
      );
}
