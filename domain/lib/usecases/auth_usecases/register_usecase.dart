import 'package:domain/domain.dart';

class RegisterUsecase implements FutureUseCase<Map<String, String>, UserModel> {
  final UserRepository _userRepository;

  RegisterUsecase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<UserModel> execute(Map<String, String> input) async {
    return _userRepository.createUser(
      username: input['username']!,
      email: input['email']!,
      password: input['password']!,
    );
  }
}
