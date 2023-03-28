import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_conquest/widgets/screens/loading/loading_screen.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';
import 'package:ship_conquest/widgets/screens/signIn/authentication_screen.dart';

GoRouter createRouter() => 
    GoRouter(
        routes: [
          GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) => const LoadingScreen()
          ),
          GoRoute(
              path: '/signIn',
              builder: (BuildContext context, GoRouterState state) => const AuthenticationScreen()
          ),
          GoRoute(
              path: '/game',
              builder: (BuildContext context, GoRouterState state) => GameScreen()
          )
        ]
    );