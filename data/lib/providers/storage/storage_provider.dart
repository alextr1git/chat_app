import 'dart:io';

import 'package:domain/domain.dart';

abstract class StorageProvider {
  Future<String?> uploadImage({required File image, required String userId});
  Future<String> downloadImage({required String userId});
}
