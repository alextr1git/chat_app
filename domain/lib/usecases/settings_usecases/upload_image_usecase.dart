import 'dart:io';

import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class UploadImageUseCase implements FutureUseCase<File?, NoParams> {
  final UserRepository _userRepository;

  UploadImageUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<NoParams> execute(File? image) async {
    if (image != null) {
      await _userRepository.uploadImage(image);
    }

    return const NoParams();
  }
}
