import 'package:domain/domain.dart';

class GetUserUseCase extends FutureUseCase<NoParams, UserModel?> {
  final UserRepository _userRepository;

  GetUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<UserModel?> execute(NoParams input) async {
    UserModel? userModel = _userRepository.getCurrentUser();
    return userModel;
  }
}
