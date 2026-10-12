import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/states/auth_notifier.dart';

final authNotifierProvider = StreamNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
