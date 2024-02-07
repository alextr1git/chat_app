import 'dart:async';
import 'dart:io';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageProviderImpl implements StorageProvider {
  @override
  Future<String?> uploadImage({
    required File image,
    required String userId,
  }) async {
    try {
      Reference ref = dataDI.firebaseStorageRef.child("photos/$userId.jpg");
      ref.putFile(image);
      return ("photos/$userId.jpg");
    } catch (e) {
      throw CannotUploadPhotoException();
    }
  }

  @override
  Future<String> downloadImage({
    required String userId,
  }) async {
    String photoUrl = ("photos/$userId.jpg");
    Reference ref = dataDI.firebaseStorageRef.child(photoUrl);

    final appDocDir = await getApplicationDocumentsDirectory();

    final filePath =
        path.join(appDocDir.absolute.path, 'photos', '$userId.jpg');
    final file = File(filePath);

    final downloadTask = ref.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        return;
      }
    });
    return filePath;
  }
}
