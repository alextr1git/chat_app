import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class SetUsernameUseCase implements FutureUseCase<String, NoParams> {
  final UserRepository _userRepository;

  SetUsernameUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<NoParams> execute(String input) async {
    _userRepository.setUsername(input);
    return const NoParams();
  }
}
