import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mylibrary/auth/core/ibase_auth.dart';
import 'package:mylibrary/auth/impl/default_auth_repository.dart';
import 'package:mylibrary/auth/impl/google_auth_repository.dart';

class BaseAuth implements IBaseAuth {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  new({required this.auth, required this.googleSignIn});

  @override
  Stream<User?> get getChanges => auth.userChanges();

  @override
  DefaultAuthRepository defaultAuthRepository() {
    return DefaultAuthRepository(auth: auth);
  }

  @override
  GoogleAuthRepository googleAuthRepository() {
    return GoogleAuthRepository(googleSignIn: googleSignIn, auth: auth);
  }
}
