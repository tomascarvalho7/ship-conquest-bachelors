
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/ship/static_ship.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/ship_manager.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/router.dart';
import 'package:ship_conquest/services/ship_services/fake_ship_services.dart';
import 'package:ship_conquest/services/ship_services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'domain/ship/direction.dart';
import 'domain/space/position.dart';

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
          Provider<UserStorage>(create: (_) => UserStorage()),
          ProxyProvider<UserStorage, ShipServices>(
              update: (_, userStorage, __) => RealShipServices(userStorage: userStorage)
          ),
          ChangeNotifierProvider(create: (_) => MinimapProvider()) // needs to be in the next layer, game but there are complications
        ],
        child: MaterialApp.router(
            title: 'Ship Conquest',
            theme: ThemeData(primarySwatch: Colors.blue),
            routerConfig: createRouter()
        )
    );
  }

}