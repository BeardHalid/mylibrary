import 'package:firebase_auth/firebase_auth.dart';
import 'package:mylibrary/auth/impl/default_auth_repository.dart';
import 'package:mylibrary/auth/impl/google_auth_repository.dart';

abstract interface class IBaseAuth {
  Stream<User?> get getChanges;
  DefaultAuthRepository defaultAuthRepository();
  GoogleAuthRepository googleAuthRepository();
}
