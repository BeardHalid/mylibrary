import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/states/genres_detail_riverpod.dart';

class GenresDetailScreen extends ConsumerWidget {
  final String genre;
  const GenresDetailScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genresDetailPrv = ref.watch(booksByGenresProvider(genre));
    return Scaffold(
      appBar: AppBar(title: Text(genre, style: TextStyle(fontSize: 15.0))),
      body: genresDetailPrv.when(
        data: (data) {
          if (data != null) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final book = data[index];
                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        book.coverImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(10.0),
                                child: Image.network(
                                  book.coverImage!,
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
                              Text(book.title ?? 'Başlık Yok', style: TextStyle(fontSize: 14.0)),
                              Constants.verticalGap(10),
                              Text(
                                book.authors != null ? book.authors!.first.name! : 'Yazar Yok',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Veri bulunamadı :('));
          }
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}
