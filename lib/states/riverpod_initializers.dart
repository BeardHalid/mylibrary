import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mylibrary/auth/core/ibase_auth.dart';
import 'package:mylibrary/auth/impl/base_auth.dart';
import 'package:mylibrary/repository/impl/base_repository.dart';
import 'package:mylibrary/storage/storage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//starter initializers

final _dioProvider = Provider((ref) {
  return Dio();
});

final _supabaseProvider = Provider((ref) {
  return Supabase.instance.client;
});

final _storageProvier = Provider((ref) {
  return FirebaseStorage.instance;
});

//Repository initializers

final baseRepositoryProvider = Provider<BaseRepository>((ref) {
  final dioPrv = ref.watch(_dioProvider);
  final supabasePrv = ref.watch(_supabaseProvider);
  return BaseRepository(client: supabasePrv, dio: dioPrv);
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storagePrv = ref.watch(_storageProvier);
  return StorageRepository(storage: storagePrv);
});

//Auth initializers

final _firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final _googleAuthProvider = Provider((ref) {
  return GoogleSignIn.instance;
});

final authRepositoryProvider = Provider<IBaseAuth>((ref) {
  final firebaseAuthPrv = ref.watch(_firebaseAuthProvider);
  final googleAuthPrv = ref.watch(_googleAuthProvider);
  return BaseAuth(auth: firebaseAuthPrv, googleSignIn: googleAuthPrv);
});
