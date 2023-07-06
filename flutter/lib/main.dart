import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/app_theme.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/game/game_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/scene_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/schedule_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/ship_controller.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/providers/game/global_controllers/minimap_controller.dart';
import 'package:ship_conquest/providers/sound_controller.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/config/router/create_router.dart';
import 'package:ship_conquest/services/ship_services/fake_ship_services.dart';
import 'package:ship_conquest/services/ship_services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

void main() {
  runApp(const MyApp());
}

/// The root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Instantiates the app's providers and the router.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LobbyStorage>(create: (_) => LobbyStorage()),
          Provider<UserStorage>(create: (_) => UserStorage()),
          ProxyProvider2<UserStorage, LobbyStorage, ShipServices>(
              update: (_, userStorage, lobbyStorage, __) => FakeShipServices(userStorage: userStorage, lobbyStorage: lobbyStorage)
          ),
          Provider(create: (_) => GlobalState()),
          Provider(create: (_) => ScheduleController()),
          Provider(create: (_) => SoundController()),
          ChangeNotifierProvider(create: (_) => ShipController()),
          ChangeNotifierProvider(create: (_) => SceneController()),
          ChangeNotifierProvider(create: (_) => MinimapController()),
          ChangeNotifierProvider(create: (_) => StatisticsController()),
          ChangeNotifierProvider(create: (_) => FeedbackController()),
          Provider<GameController>(create: (gameContext) =>
              GameController(
                  shipController: gameContext.read<ShipController>(),
                  statisticsController: gameContext.read<StatisticsController>(),
                  minimapController: gameContext.read<MinimapController>(),
                  sceneController: gameContext.read<SceneController>(),
                  services: gameContext.read<ShipServices>(),
                  scheduleController: gameContext.read<ScheduleController>(),
                  feedbackController: gameContext.read<FeedbackController>(),
                  soundController: gameContext.read<SoundController>()
              )
          ),
        ],
          child: MaterialApp.router(
              scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
              title: 'Ship Conquest',
              theme: shipConquestLightTheme,
              darkTheme: shipConquestDarkTheme,
              routerConfig: createRouter()
          )
      );
  }
}