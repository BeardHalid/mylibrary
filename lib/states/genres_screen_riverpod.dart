import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/api_constants.dart';
import 'package:mylibrary/models/genre.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

final genreListProvider = FutureProvider<List<Genre>?>((ref) async {
  final baseRepoProvider = ref.watch(baseRepositoryProvider);
  return baseRepoProvider
      .gutenberg<Genre>(fromJson: (json) => Genre.fromJson(json))
      .getAll(ApiConstants.genresTable);
});
