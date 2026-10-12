import 'package:flutter_riverpod/legacy.dart';
import 'package:mylibrary/exception/base_exception.dart';

final errorCatchProvider = StateProvider<BaseException?>((ref) {
  return null;
});
