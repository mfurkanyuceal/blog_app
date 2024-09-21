import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository repository;

  UserSignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await repository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
