import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';
import 'package:ship_conquest/widgets/screens/lobby/lobby.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_screen.dart';
import 'package:ship_conquest/widgets/screens/profile/user_profile.dart';
import 'package:ship_conquest/widgets/screens/signIn/authentication_screen.dart';
import 'package:ship_conquest/widgets/screens/start_menu/start_menu.dart';

import '../../widgets/screens/game_loading/game_loading_screen.dart';
import '../../widgets/screens/initial_loading/loading_screen.dart';

GoRouter createRouter() =>
    GoRouter(
        routes: [
          GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) => const InitialLoadingScreen()
          ),
          GoRoute(
              path: '/signIn',
              builder: (BuildContext context, GoRouterState state) => const AuthenticationScreen()
          ),
          GoRoute(
              path: '/start',
              builder: (BuildContext context, GoRouterState state) => const StartMenuScreen()
          ),          GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) => const ProfileScreen()
          ),          GoRoute(
              path: '/lobby',
              builder: (BuildContext context, GoRouterState state) => const LobbyScreen()
          ),
          GoRoute(
              path: '/loading/:dst',
              builder: (BuildContext context, GoRouterState state) => GameLoadingScreen(dst: state.params['dst']!)
          ),
          GoRoute(
              path: '/game',
              redirect: (context, _) => !context.read<GlobalState>().isPlayable ? '/loading/game' : null,
              builder: (BuildContext context, GoRouterState state) {
                final globalState = context.read<GlobalState>();
                return GameScreen(
                  data: globalState.gameData!,
                  stats: globalState.playerStats!,
                );
              }
          ),
          GoRoute(
              path: '/minimap',
              redirect: (context, _) => context.read<GlobalState>().gameData == null ? '/loading/minimap' : null,
              builder: (BuildContext context, GoRouterState state) => MinimapScreen(data: context.read<GlobalState>().gameData!)
          ),
        ]
    );