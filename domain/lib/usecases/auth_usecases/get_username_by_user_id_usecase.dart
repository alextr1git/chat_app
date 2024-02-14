import 'package:domain/domain.dart';

class GetUsernameByIDUseCase implements FutureUseCase<String, String> {
  final UserRepository _userRepository;

  GetUsernameByIDUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<String> execute(String userID) async {
    return await _userRepository.getUsernameByID(userID);
  }
}
