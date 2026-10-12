import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/api_constants.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

final booksByGenresProvider = FutureProvider.autoDispose.family<List<Book>?, String>((
  ref,
  query,
) async {
  final baseRepo = ref.watch(baseRepositoryProvider);
  return baseRepo
      .gutenberg(fromJson: (json) => Book.fromJson(json))
      .search(ApiConstants.booksTable, 'subject', query);
});
