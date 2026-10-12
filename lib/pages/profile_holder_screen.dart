import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/pages/login_screen.dart';
import 'package:mylibrary/pages/user_details_screen.dart';
import 'package:mylibrary/states/auth_riverpod.dart';

class ProfileHolderScreen extends ConsumerWidget {
  const ProfileHolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatePrv = ref.watch(authNotifierProvider);
    return authStatePrv.when(
      data: (user) {
        if (user != null) {
          return UserDetailsScreen();
        } else {
          return LoginScreen();
        }
      },
      error: (error, st) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
