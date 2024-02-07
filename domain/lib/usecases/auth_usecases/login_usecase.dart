import 'package:domain/domain.dart';

class LoginUseCase implements FutureUseCase<Map<String, String>, UserModel> {
  final UserRepository _userRepository;

  LoginUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<UserModel> execute(Map<String, String> input) async {
    return _userRepository.logInUser(
      email: input['email']!,
      password: input['password']!,
    );
  }
}
