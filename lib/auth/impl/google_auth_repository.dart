import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mylibrary/auth/core/igoogle_auth_repository.dart';

class GoogleAuthRepository implements IGoogleAuthRepository {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  new({required this._googleSignIn, required this._auth});

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(serverClientId: dotenv.get('FIREBASE_SERVER_CLIENT_ID'));
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      final message = switch (e.code) {
        GoogleSignInExceptionCode.canceled => 'Google ile giriş iptal edildi.',
        GoogleSignInExceptionCode.interrupted => 'Google ile giriş kesintiye uğradı.',
        GoogleSignInExceptionCode.clientConfigurationError =>
          'Google ile giriş yapılandırması hatalı: ${e.description ?? 'istemci ayarlarını kontrol edin.'}',
        GoogleSignInExceptionCode.providerConfigurationError =>
          'Google kimlik doğrulama sağlayıcısı kullanılamıyor veya hatalı yapılandırılmış.',
        GoogleSignInExceptionCode.uiUnavailable => 'Google ile giriş ekranı şu anda açılamıyor.',
        GoogleSignInExceptionCode.userMismatch =>
          'Google ile giriş işlemi mevcut kullanıcıyla eşleşmiyor.',
        GoogleSignInExceptionCode.unknownError =>
          'Google ile giriş sırasında bilinmeyen bir hata oluştu: ${e.description ?? ''}',
      };
      log(message);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (e) {
      log('Failed to sign out from Google: $e');
      rethrow;
    }
  }
}
