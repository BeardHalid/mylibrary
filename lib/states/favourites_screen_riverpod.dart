import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/models/favourite.dart';
import 'package:mylibrary/states/favourites_notifier.dart';

final favouritesListProvider = AsyncNotifierProvider<FavouritesNotifier, List<Favourite>?>(
  FavouritesNotifier.new,
);
