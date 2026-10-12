import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/home_screen_riverpod.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _suggestionsController = OverlayPortalController();
  final _searchFieldKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? Consumer(
              builder: (context, searchBarState, child) {
                final searchResults = searchBarState.watch(searchBarProvider);
                return LayoutBuilder(
                  builder: (context, _) {
                    final mediaQuery = MediaQuery.of(context);
                    final screenSize = mediaQuery.size;
                    final fieldRenderObject = _searchFieldKey.currentContext?.findRenderObject();
                    final fieldBottom = fieldRenderObject is RenderBox
                        ? fieldRenderObject
                              .localToGlobal(Offset(0, fieldRenderObject.size.height))
                              .dy
                        : null;
                    final listTop = (fieldBottom ?? mediaQuery.padding.top + kToolbarHeight) + 4;
                    final listBottom = screenSize.height - mediaQuery.padding.bottom;
                    final availableHeight = (listBottom - listTop).clamp(0.0, double.infinity);
                    final horizontalInset = mediaQuery.padding.left + 16;
                    final listWidth =
                        screenSize.width - mediaQuery.padding.left - mediaQuery.padding.right - 32;

                    return OverlayPortal(
                      controller: _suggestionsController,
                      overlayChildBuilder: (context) => Positioned(
                        top: listTop,
                        left: horizontalInset,
                        width: listWidth,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: availableHeight),
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: searchResults.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                              error: (error, stackTrace) => const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Arama sonuçları yüklenemedi',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              data: (books) {
                                final results = books ?? const <Book>[];
                                if (results.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Sonuç bulunamadı', textAlign: TextAlign.center),
                                  );
                                }

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: results.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) => ListTile(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.bookDetailScreen,
                                        extra: results[index],
                                      );
                                      _suggestionsController.hide();
                                      _searchController.clear();
                                      _searchFocusNode.unfocus();
                                      setState(() {
                                        _isSearching = false;
                                      });
                                    },
                                    dense: true,
                                    title: Text(
                                      results[index].title ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        key: _searchFieldKey,
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Ara',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              _suggestionsController.hide();
                            } else {
                              _suggestionsController.show();
                            }
                            searchBarState.read(searchBarProvider.notifier).searchBooks(value);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Text(widget.title),
      actions: [
        IconButton(
          tooltip: _isSearching ? 'Aramayı kapat' : 'Ara',
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            if (_isSearching) {
              _suggestionsController.hide();
              _searchController.clear();
              _searchFocusNode.unfocus();
            }
            setState(() => _isSearching = !_isSearching);
          },
        ),
      ],
    );
  }
}
