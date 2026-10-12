import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/api_constants.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

class SearchBarNotifier extends AsyncNotifier<List<Book>?> {
  int _latestSearchId = 0;

  @override
  Future<List<Book>?> build() async {
    return <Book>[];
  }

  Future<void> searchBooks(String query) async {
    final searchId = ++_latestSearchId;
    final baseRepoProvider = ref.read(baseRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      final books = await baseRepoProvider
          .gutenberg<Book>(fromJson: (json) => Book.fromJson(json))
          .search(ApiConstants.booksTable, 'title', query);
      if (searchId == _latestSearchId) {
        state = AsyncValue.data(books);
      }
    } catch (e, st) {
      if (searchId == _latestSearchId) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}
