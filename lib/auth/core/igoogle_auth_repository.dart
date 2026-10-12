import 'package:mylibrary/auth/core/iauth_repository.dart';

abstract interface class IGoogleAuthRepository implements IAuthRepository {
  Future<void> signInWithGoogle();
}
