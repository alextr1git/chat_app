import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetUsernameByIDUsecase implements FutureUseCase<String, String> {
  final UserRepository _userRepository;

  GetUsernameByIDUsecase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<String> execute(String userID) async {
    return await _userRepository.getUsernameByID(userID);
  }
}
