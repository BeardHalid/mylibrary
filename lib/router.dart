import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/pages/book_detail_screen.dart';
import 'package:mylibrary/pages/genres_detail_screen.dart';
import 'package:mylibrary/pages/genres_screen.dart';
import 'package:mylibrary/pages/favourites_screen.dart';
import 'package:mylibrary/pages/home_screen.dart';
import 'package:mylibrary/pages/login_screen.dart';
import 'package:mylibrary/pages/main_screen.dart';
import 'package:mylibrary/pages/profile_holder_screen.dart';
import 'package:mylibrary/pages/register_screen.dart';
import 'package:mylibrary/pages/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String homeScreen = '/home';
  static const String genresScreen = '/genres';
  static const String favouritesScreen = '/favourites';
  //static const String settingsScreen = '/settings';
  static const String bookDetailScreen = '/book_detail';
  static const String genresDetailScreen = 'genres_detail';
  static const String profileHolderScreen = '/profile';

  static final routes = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splashScreen,
    routes: [
      GoRoute(path: splashScreen, builder: (context, state) => SplashScreen()),
      GoRoute(path: registerScreen, builder: (context, state) => RegisterScreen()),
      GoRoute(path: loginScreen, builder: (context, state) => LoginScreen()),
      GoRoute(
        path: bookDetailScreen,
        builder: (context, state) {
          final book = state.extra as Book;
          return BookDetailScreen(book: book);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            navigationShell: navigationShell,
          ); // Replace with your main screen widget
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: homeScreen, builder: (context, state) => HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: genresScreen,
                builder: (context, state) => GenresScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: genresDetailScreen,
                    builder: (context, state) {
                      final genre = state.extra as String;
                      return GenresDetailScreen(genre: genre);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: favouritesScreen, builder: (context, state) => FavouritesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profileHolderScreen,
                builder: (context, state) => ProfileHolderScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
