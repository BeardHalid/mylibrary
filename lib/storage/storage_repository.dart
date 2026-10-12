import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:mylibrary/storage/istorage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository implements IStorageRepository {
  final FirebaseStorage _storage;

  StorageRepository({required this._storage});

  @override
  Future<String?> get() async {
    return await _storage.ref().getDownloadURL();
  }

  @override
  Future<String> set(File file, String imageName) async {
    final storageRef = _storage.ref().child('images/$imageName');
    try {
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      log('Hata : $e');
      rethrow;
    }
  }

  @override
  Future<void> update(Uint8List data) async {
    await _storage.ref().delete();
    await _storage.ref().putData(data);
  }
}
