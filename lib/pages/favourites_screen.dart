import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/auth_riverpod.dart';
import 'package:mylibrary/states/favourites_screen_riverpod.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesListPrv = ref.watch(favouritesListProvider);
    final authState = ref.watch(authNotifierProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          return favouritesListPrv.when(
            data: (data) {
              if (data != null || data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final favourite = data[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Slidable(
                        key: ValueKey(favourite.id ?? index),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) {
                                log(favourite.id.toString());
                                ref
                                    .read(favouritesListProvider.notifier)
                                    .deleteFromFavourite(favourite.id!);
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.delete), SizedBox(height: 4.0), Text('Sil')],
                              ),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            final book = Book(
                              id: favourite.id ?? 0,
                              title: favourite.title ?? 'Başlık yok',
                              authors: favourite.authors ?? [],
                              coverImage: favourite.coverImage ?? 'Resim yok',
                              summary: favourite.summary ?? 'Özet yok',
                            );
                            context.push(AppRoutes.bookDetailScreen, extra: book);
                          },
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  favourite.coverImage != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(10.0),
                                          child: Image.network(
                                            favourite.coverImage!,
                                            fit: BoxFit.fill,
                                            width: 100,
                                          ),
                                        )
                                      : const Placeholder(),
                                  Constants.horizontalGap(10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favourite.title ?? 'Başlık Yok',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Constants.verticalGap(10),
                                        Text(
                                          favourite.authors?.first.name ?? 'Yazar Yok',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('Veri bulunamadı :('));
              }
            },
            error: (error, st) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text('Bu sayfayı görebilmek için giriş yapmalısınız!'));
        }
      },
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
