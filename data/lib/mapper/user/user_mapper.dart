import 'package:data/data.dart';
import 'package:domain/domain.dart';

abstract class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      isEmailVerified: model.isEmailVerified,
      photoURL: model.photoURL,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      isEmailVerified: entity.isEmailVerified,
      photoURL: entity.photoURL,
    );
  }
}
