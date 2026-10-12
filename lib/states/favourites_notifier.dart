import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/models/favourite.dart';
import 'package:mylibrary/states/riverpod_initializers.dart';

class FavouritesNotifier extends AsyncNotifier<List<Favourite>?> {
  FavouritesNotifier();
  @override
  Future<List<Favourite>?> build() async {
    final baseRepoPrv = ref.watch(baseRepositoryProvider);
    return await baseRepoPrv
        .supabase<Favourite>(fromJson: (json) => Favourite.fromJson(json))
        .getAll('favourites');
  }

  Future<bool> addFavourite(Favourite fav) async {
    final previousState = state.value;
    final baseRepoPrv = ref.read(baseRepositoryProvider);
    bool isFavAdded = await baseRepoPrv
        .supabase<Favourite>(fromJson: (json) => Favourite.fromJson(json))
        .set('favourites', fav, fav.id!);
    if (isFavAdded) {
      state = const AsyncLoading();
      if (previousState != null) {
        state = AsyncData([...previousState, fav]);
      }
    }
    return isFavAdded;
  }

  Future<void> deleteFromFavourite(int id) async {
    final baseRepoPrv = ref.read(baseRepositoryProvider);
    state = const AsyncLoading();
    try {
      await baseRepoPrv
          .supabase<Favourite>(fromJson: (json) => Favourite.fromJson(json))
          .delete('favourites', id);

      update((items) {
        final newList = items?.where((item) => item.id != id).toList();
        return newList;
      });
    } catch (e) {
      rethrow;
    }
  }
}
