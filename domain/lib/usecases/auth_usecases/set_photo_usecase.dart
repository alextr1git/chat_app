import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class SetUserPhotoURLUseCase implements FutureUseCase<String, NoParams> {
  final UserRepository _userRepository;

  SetUserPhotoURLUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<NoParams> execute(String input) async {
    _userRepository.setUserPhoto(input);
    return const NoParams();
  }
}
