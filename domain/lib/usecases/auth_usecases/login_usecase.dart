import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class LoginUsecase implements FutureUseCase<Map<String, String>, UserModel> {
  final UserRepository _userRepository;

  LoginUsecase({
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
