import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/home_screen_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookListPrv = ref.watch(bookListProvider);
    return bookListPrv.when(
      data: (data) {
        if (data != null) {
          return GridView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final book = data[index];
              return GestureDetector(
                onTap: () => context.push(AppRoutes.bookDetailScreen, extra: book),
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        book.coverImage != null
                            ? Image.network(
                                book.coverImage!,
                                width: Constants.screenWidth(context) * 0.20,
                                height: Constants.screenHeight(context) * 0.12,
                              )
                            : const Placeholder(),
                        book.title != null
                            ? Expanded(
                                child: Align(
                                  child: Text(
                                    book.title!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                              )
                            : Text('Veri Bulunamadı'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Veri Bulunamadı'));
        }
      },
      error: (error, st) => Center(child: Text(error.toString())),
      loading: () => Center(child: const CircularProgressIndicator()),
    );
  }
}
