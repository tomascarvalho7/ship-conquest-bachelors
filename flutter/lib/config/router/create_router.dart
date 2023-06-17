import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_conquest/widgets/overlay_widget.dart';
import 'package:ship_conquest/widgets/screens/authentication/authentication_screen.dart';
import 'package:ship_conquest/widgets/screens/game_loading/game_loading_screen.dart';
import 'package:ship_conquest/widgets/screens/initial_loading/initial_loading_screen.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_screen.dart';
import 'package:ship_conquest/widgets/screens/pages/game_ui.dart';
import 'package:ship_conquest/widgets/screens/pages/home_screen.dart';


/// Creates and returns a GoRouter instance with the specified
/// initial location and routes.
/// The routes will be used for the application's navigation.
GoRouter createRouter() => GoRouter(
    initialLocation: "/",
    routes: [
      // Shell route allows the usage of a widget present in all the
      // children's screens
      ShellRoute(
          builder: (context, state, child) {
            return OverlayWidget(child: child);
          } ,
          routes: [
            GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) =>
                const InitialLoadingScreen()),
            GoRoute(
                path: '/signIn',
                builder: (BuildContext context, GoRouterState state) =>
                const AuthenticationScreen()),
            GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) =>
                const HomeScreen()),
            GoRoute(
                path: '/game-home',
                builder: (BuildContext context, GoRouterState state) =>
                const GameUI()),
            GoRoute(
                path: '/loading-game',
                builder: (BuildContext context, GoRouterState state) => const GameLoadingScreen()),
            GoRoute(
                path: '/minimap',
                builder: (BuildContext context, GoRouterState state) => const MinimapScreen()),
          ]),
    ]);
