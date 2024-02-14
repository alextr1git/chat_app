import 'package:domain/domain.dart';

class LogoutUserUseCase implements FutureUseCase<NoParams, NoParams> {
  final UserRepository _userRepository;

  LogoutUserUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<NoParams> execute(NoParams input) async {
    await _userRepository.logOutUser();
    return const NoParams();
  }
}
