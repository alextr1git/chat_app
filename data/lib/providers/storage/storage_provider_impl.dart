import 'dart:async';
import 'dart:io';
import 'package:core/core.dart';
import 'package:data/exceptions/storage_exceptions.dart';
import 'package:data/providers/storage/storage_provider.dart';
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
      /*
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});*/
      return ("photos/$userId.jpg");
    } on FirebaseException catch (e) {
      print(e.toString());
      throw GenericStorageException();
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
