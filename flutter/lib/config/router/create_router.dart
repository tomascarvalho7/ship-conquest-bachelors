import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/widgets/screens/bottom_navigation_bar/bottom_bar.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';
import 'package:ship_conquest/widgets/screens/pages/game_ui.dart';
import 'package:ship_conquest/widgets/screens/pages/home_screen.dart';
import 'package:ship_conquest/widgets/screens/lobby/lobby.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_screen.dart';
import 'package:ship_conquest/widgets/screens/profile/user_profile.dart';
import 'package:ship_conquest/widgets/screens/signIn/authentication_screen.dart';

import '../../widgets/screens/game_loading/game_loading_screen.dart';
import '../../widgets/screens/initial_loading/loading_screen.dart';
import '../../widgets/screens/start_menu/start_menu.dart';

GoRouter createRouter() => GoRouter(initialLocation: "/", routes: [
      ShellRoute(
          /*builder: (context, state, child) {
            return BottomBar(child);
          },*/
          routes: [
            GoRoute(
                path: '/start',
                builder: (BuildContext context, GoRouterState state) =>
                    const StartMenuScreen()),
            GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen()),
            GoRoute(
                path: '/lobby',
                builder: (BuildContext context, GoRouterState state) =>
                    const LobbyScreen()),
          ]),
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const InitialLoadingScreen()),
      GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen()),
      GoRoute(
          path: '/game-home',
          builder: (BuildContext context, GoRouterState state) =>
              const GameUI()),
      GoRoute(
          path: '/signIn',
          builder: (BuildContext context, GoRouterState state) =>
              const AuthenticationScreen()),
      GoRoute(
          path: '/loading/:dst',
          builder: (BuildContext context, GoRouterState state) =>
              GameLoadingScreen(dst: state.params['dst']!)),
      GoRoute(
          path: '/game',
          builder: (BuildContext context, GoRouterState state) => const GameScreen()),
      GoRoute(
          path: '/minimap',
          builder: (BuildContext context, GoRouterState state) => const MinimapScreen()),
    ]);
