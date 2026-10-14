import 'package:mylibrary/auth/core/iauth_repository.dart';

abstract interface class IDefaultAuthRepository implements IAuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String newPassword);
  Future<void> updatePhotoURL(String url);
  Future<void> updateDisplayName(String displayName);
  Future<void> updatePhoneNumber(String phoneNumber, String smsCode);
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(Object error) onVerificationFailed,
    required void Function() onVerificationCompleted,
  });
}
