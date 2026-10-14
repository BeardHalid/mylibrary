import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mylibrary/auth/core/idefault_auth_repository.dart';

class DefaultAuthRepository implements IDefaultAuthRepository {
  final FirebaseAuth _auth;

  new({required this._auth});

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('Şifre sıfırlama maili gönderilemedi : $e');
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final authResponse = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (authResponse.user == null) {
        throw Exception('Sign-in failed: No user returned');
      } else {
        log('Sign-in successful for email: $email');
      }
    } catch (e) {
      log('Failed to sign in: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log('Sign-out successful');
    } catch (e) {
      log('Failed to sign out : $e');
      rethrow;
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      final signUpResponse = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (signUpResponse.user == null) {
        throw Exception('Sign-up failed: No user returned');
      } else {
        log('Sign-up successful for email: $email');
      }
    } catch (e) {
      log('Failed to sign up: $e');
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        user.updatePassword(newPassword);
      } else {
        log('Kullanıcı bulunamadı');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updatePhotoURL(String url) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePhotoURL(url);
      } else {
        log('Kullanıcı bulunamadı');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
      } else {
        log('Kullanıcı bulunamadı');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await user.updatePhoneNumber(credential);
            log('Telefon numarası başarıyla güncellendi');
          },
          verificationFailed: (FirebaseAuthException e) {
            log('Telefon numarası doğrulanamadı: $e');
          },
          codeSent: (String verificationId, int? resendToken) {
            log('Telefon numarasına doğrulama kodu gönderildi');
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        log('Kullanıcı bulunamadı');
      }
    } catch (e) {
      log('Telefon numarası güncellenemedi: $e');
      rethrow;
    }
  }
}
