import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/states/main_screen_riverpod.dart';
import 'package:mylibrary/widgets/custom_app_bar.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell _navigationShell;
  const MainScreen({super.key, required this._navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleChangePrv = ref.watch(titleChangeProvider);
    final pagesMap = {
      Icons.home: 'Anasayfa',
      Icons.category: 'Türler',
      Icons.favorite: 'Favoriler',
      Icons.account_box: 'Profil',
    };

    return Scaffold(
      appBar: CustomAppBar(title: titleChangePrv),
      body: _navigationShell,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          _navigationShell.goBranch(value);
          ref.read(titleChangeProvider.notifier).state = pagesMap.values.elementAt(value);
        },
        selectedIndex: _navigationShell.currentIndex,
        destinations: List.generate(pagesMap.length, (index) {
          final destinationItem = pagesMap.entries.elementAt(index);
          return NavigationDestination(
            icon: Icon(destinationItem.key),
            label: destinationItem.value,
          );
        }),
      ),
    );
  }
}
