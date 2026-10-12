import 'dart:io';

import 'package:flutter/foundation.dart';

abstract interface class IStorageRepository {
  Future<String?> get();
  Future<String> set(File file, String imageName);
  Future<void> update(Uint8List data);
}
