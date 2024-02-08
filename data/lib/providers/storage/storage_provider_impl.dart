import 'dart:async';
import 'dart:io';
import 'package:data/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageProviderImpl implements StorageProvider {
  final FirebaseStorage _firebaseStorage;

  StorageProviderImpl({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;
  @override
  Future<String?> uploadImage({
    required File image,
    required String userId,
  }) async {
    final Reference databaseReference = _firebaseStorage.ref();
    try {
      Reference ref = databaseReference.child("photos/$userId.jpg");
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
    final Reference databaseReference = _firebaseStorage.ref();
    String photoUrl = ("photos/$userId.jpg");
    Reference ref = databaseReference.child(photoUrl);

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
