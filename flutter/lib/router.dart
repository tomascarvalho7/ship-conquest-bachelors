import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/ship/dynamic_ship.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/loading/loading_screen.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_screen.dart';
import 'package:ship_conquest/widgets/screens/signIn/authentication_screen.dart';

import 'domain/ship/direction.dart';
import 'domain/ship/ship.dart';
import 'domain/ship/static_ship.dart';
import 'domain/space/position.dart';

GoRouter createRouter() {

  return GoRouter(routes: [
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
        const LoadingScreen()),
    GoRoute(
        path: '/signIn',
        builder: (BuildContext context, GoRouterState state) =>
        const AuthenticationScreen()),
    GoRoute(
      path: '/game',
      builder: (BuildContext context, GoRouterState state) {
        final services = Provider.of<ShipServices>(context);

        return FutureBuilder(
          future: Future.wait([
            services.getMainShipPosition(),
            services.getMainShipPath(),
          ]),
          builder: (_, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData && data != null) {
              final position = data[0] as Position?;
              final path = data[1] as ShipPath?;

              final Ship ship = position != null
                  ? StaticShip(position: position, orientation: Direction.up)
                  : path != null
                  ? DynamicShip(path: path)
                  : throw Exception("change this later");

              return ChangeNotifierProvider(
                create: (_) => ShipManager(
                  ships: [ship],
                ),
                child: GameScreen(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
      routes: [
        GoRoute(
            path: 'minimap',
            builder: (BuildContext context, GoRouterState state) =>  const MinimapScreen()
        )
      ],
    )
  ]);

}