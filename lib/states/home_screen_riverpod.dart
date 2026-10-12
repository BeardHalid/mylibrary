import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/api_constants.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';
import 'package:mylibrary/states/searchbar_notifier.dart';

final bookListProvider = FutureProvider<List<Book>?>((ref) async {
  final baseRepoProvider = ref.watch(baseRepositoryProvider);
  return baseRepoProvider
      .gutenberg<Book>(fromJson: (json) => Book.fromJson(json))
      .getAll(ApiConstants.booksTable);
});

final searchBarProvider = AsyncNotifierProvider<SearchBarNotifier, List<Book>?>(
  () {
    return SearchBarNotifier();
  },
);
