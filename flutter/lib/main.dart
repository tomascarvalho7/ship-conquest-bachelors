import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/app_theme.dart';
import 'package:ship_conquest/providers/game/game_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/schedule_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/config/router/create_router.dart';
import 'package:ship_conquest/services/ship_services/fake_ship_services.dart';
import 'package:ship_conquest/services/ship_services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LobbyStorage>(create: (_) => LobbyStorage()),
          Provider<UserStorage>(create: (_) => UserStorage()),
          ProxyProvider2<UserStorage, LobbyStorage, ShipServices>(
              update: (_, userStorage, lobbyStorage, __) => RealShipServices(userStorage: userStorage, lobbyStorage: lobbyStorage)
          ),
          Provider(create: (_) => GlobalState()),
          Provider(create: (_) => ScheduleController()),
          ChangeNotifierProvider(create: (_) => ShipController()),
          ChangeNotifierProvider(create: (_) => SceneController()),
          ChangeNotifierProvider(create: (_) => MinimapController()),
          ChangeNotifierProvider(create: (_) => StatisticsController()),
          Provider<GameController>(create: (gameContext) =>
              GameController(
                  shipController: gameContext.read<ShipController>(),
                  statisticsController: gameContext.read<StatisticsController>(),
                  minimapController: gameContext.read<MinimapController>(),
                  sceneController: gameContext.read<SceneController>(),
                  services: gameContext.read<ShipServices>(),
                  scheduleController: gameContext.read<ScheduleController>()
              )
          ),
        ],
        child: MaterialApp.router(
            title: 'Ship Conquest',
            theme: shipConquestLightTheme,
            darkTheme: shipConquestDarkTheme,
            routerConfig: createRouter()
        )
    );
  }
}