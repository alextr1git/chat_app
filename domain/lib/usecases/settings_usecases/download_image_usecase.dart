import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class DownloadImageUseCase implements FutureUseCase<NoParams, String> {
  final UserRepository _userRepository;

  DownloadImageUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<String> execute(NoParams noParams) async {
    return await _userRepository.downloadImage();
  }
}
