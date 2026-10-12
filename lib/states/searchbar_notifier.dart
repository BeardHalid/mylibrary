import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/api_constants.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

class SearchBarNotifier extends AsyncNotifier<List<Book>?> {
  @override
  Future<List<Book>?> build() async {
    return <Book>[];
  }

  Future<void> searchBooks(String query) async {
    final baseRepoProvider = ref.read(baseRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      state = await AsyncValue.guard(() async {
        final books = await baseRepoProvider
            .gutenberg<Book>(fromJson: (json) => Book.fromJson(json))
            .search(ApiConstants.booksTable, 'title', query);
        return books;
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
