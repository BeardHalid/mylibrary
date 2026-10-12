import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/states/home_screen_riverpod.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLogin;

  const CustomAppBar({super.key, required this.title, this.onLogin});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? Consumer(
              builder: (context, searchBarState, child) {
                final searchBarPrv = searchBarState.watch(searchBarProvider);
                return Autocomplete<String>(
                  fieldViewBuilder: (context, textEditingContoller, focusNode, onFieldSubmitted) =>
                      TextField(
                        controller: textEditingContoller,
                        autofocus: true,
                        focusNode: focusNode,
                        decoration: InputDecoration(hintText: 'Ara', border: InputBorder.none),
                        onChanged: (value) async {
                          await searchBarState.read(searchBarProvider.notifier).searchBooks(value);
                          setState(() {});
                        },
                      ),
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    return (searchBarPrv.value ?? const [])
                        .map((m) => m.title)
                        .whereType<String>()
                        .toList();
                  },
                );
              },
            )
          : Text(widget.title),
      actions: [
        IconButton(
          tooltip: _isSearching ? 'Aramayı kapat' : 'Ara',
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () => setState(() => _isSearching = !_isSearching),
        ),
      ],
    );
  }
}
