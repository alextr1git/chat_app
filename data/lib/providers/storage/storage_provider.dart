import 'dart:io';

abstract class StorageProvider {
  Future<String?> uploadImage({required File image, required String userId});
  Future<String> downloadImage({required String userId});
}
