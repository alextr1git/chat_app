import 'package:domain/domain.dart';

class CheckUserAuthenticationUseCase
    extends FutureUseCase<NoParams, UserModel> {
  final UserRepository _userRepository;

  CheckUserAuthenticationUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<UserModel> execute(NoParams input) {
    return _userRepository.checkUserAuthStatus();
  }
}
