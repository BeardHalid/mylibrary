import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/exception/base_exception.dart';
import 'package:mylibrary/states/error_catch_riverpod.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

class AuthNotifier extends StreamNotifier<User?> {
  AuthNotifier();
  @override
  Stream<User?> build() {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.getChanges;
  }

  Future<void> signIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().signIn(email, password);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.googleAuthRepository().signInWithGoogle();
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().signUp(email, password);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().signOut();
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> signOutFromGoogle() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.googleAuthRepository().signOut();
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> resetPassword(String email) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().resetPassword(email);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().updatePassword(newPassword);
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: 'Şifre güncelleme işlemi başarılı',
        color: Colors.green,
      );
    } catch (e) {
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: e.toString(),
        color: Colors.red,
      );
    }
  }

  Future<void> updatePhotoURL(String url) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().updatePhotoURL(url);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().updateDisplayName(displayName);
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: 'Kullanıcı adı güncelleme işlemi başarılı',
        color: Colors.green,
      );
    } catch (e) {
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: e.toString(),
        color: Colors.red,
      );
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.defaultAuthRepository().updatePhoneNumber(phoneNumber);
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: 'Telefon numarası güncelleme işlemi başarılı',
        color: Colors.green,
      );
    } catch (e) {
      ref.read(errorCatchProvider.notifier).state = BaseException(
        result: e.toString(),
        color: Colors.red,
      );
    }
  }
}
