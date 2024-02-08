class ChatEntity {
  final String id;
  final String title;
  final String lastMessageId;
  final int timestamp;
  final int messageCount;
  final String creatorId;
  final int color;

  ChatEntity({
    required this.id,
    required this.title,
    required this.lastMessageId,
    required this.timestamp,
    required this.messageCount,
    required this.creatorId,
    required this.color,
  });

  ChatEntity copyWith({
    String? id,
    String? title,
    String? lastMessageId,
    int? timestamp,
    int? messageCount,
    String? creatorId,
    int? color,
  }) =>
      ChatEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        timestamp: timestamp ?? this.timestamp,
        messageCount: messageCount ?? this.messageCount,
        creatorId: creatorId ?? this.creatorId,
        color: color ?? this.color,
      );

  factory ChatEntity.fromJson(Map<Object?, Object?> json, String chatId) =>
      ChatEntity(
        id: chatId,
        title: (json['title'] ?? "") as String,
        lastMessageId: (json['last-message-id'] ?? "") as String,
        timestamp: (json['timestamp'] ?? 0) as int,
        messageCount: (json['message-count'] ?? 0) as int,
        creatorId: (json['creator-id'] ?? "") as String,
        color: (json['color'] ?? 0) as int,
      );
}
