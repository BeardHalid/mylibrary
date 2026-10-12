import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/genres_screen_riverpod.dart';

class GenresScreen extends ConsumerWidget {
  const GenresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreListPrv = ref.watch(genreListProvider);
    return genreListPrv.when(
      data: (data) {
        if (data != null) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final genre = data[index];
              return ListTile(
                title: Text(genre.name!, style: TextStyle(fontSize: 15.0)),
                onTap: () => context.go(
                  '${AppRoutes.genresScreen}/${AppRoutes.genresDetailScreen}',
                  extra: genre.name,
                ),
              );
            },
          );
        } else {
          return Center(child: const Text('Veri Bulunamadı'));
        }
      },
      error: (error, st) => Center(child: Text(error.toString())),
      loading: () => Center(child: const CircularProgressIndicator()),
    );
  }
}
