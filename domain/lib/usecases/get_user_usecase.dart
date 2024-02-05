import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetUserUseCase extends FutureUseCase<NoParams, UserModel> {
  final UserRepository _userRepository;

  GetUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<UserModel> execute(NoParams input) async {
    return _userRepository.currentUser!;
  }
}
