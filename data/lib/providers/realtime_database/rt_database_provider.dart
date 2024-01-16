abstract class RealTimeDatabase {
  Future<void> postNewMessage();
  Future<void> getChatsForUser();
  Future<void> getMessagesForChat();
}
