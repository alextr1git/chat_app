import 'package:domain/domain.dart';

class SendVerificationEmailUseCase
    implements FutureUseCase<NoParams, NoParams> {
  final UserRepository _userRepository;

  SendVerificationEmailUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<NoParams> execute(NoParams) async {
    await _userRepository.sendVerification();
    return NoParams;
  }
}
