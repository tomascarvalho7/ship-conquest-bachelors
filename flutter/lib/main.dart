
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/providers/minimap_provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/config/router/create_router.dart';
import 'package:ship_conquest/services/ship_services/fake_ship_services.dart';
import 'package:ship_conquest/services/ship_services/real_ship_services.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/utils/constants.dart';

import 'domain/color/color_gradient.dart';
import 'domain/color/color_mark.dart';
import 'domain/color/color_ramp.dart';
import 'domain/utils/factor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ColorRamp colorRamp = ColorRamp(colors: [
    ColorMark(factor: Factor(0.0), color: waterColor),
    ColorMark(factor: Factor(0.01), color: const Color.fromRGBO(196, 195, 175, 1.0)),
    ColorMark(factor: Factor(0.1), color: const Color.fromRGBO(210, 202, 151, 1.0)),
    ColorMark(factor: Factor(0.15), color: const Color.fromRGBO(116, 153, 72, 1.0)),
    ColorMark(factor: Factor(0.3), color: const Color.fromRGBO(77, 130, 40, 1.0)),
    ColorMark(factor: Factor(0.7), color: const Color.fromRGBO(177, 211, 114, 1.0)),
    ColorMark(factor: Factor(0.71), color: const Color.fromRGBO(170, 145, 107, 1.0)),
    ColorMark(factor: Factor(0.85), color: const Color.fromRGBO(157, 117, 64, 1.0)),
    ColorMark(factor: Factor(1.0), color: const Color.fromRGBO(255, 255, 255, 1.0)),
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<UserStorage>(create: (_) => UserStorage()),
          ProxyProvider<UserStorage, ShipServices>(
              update: (_, userStorage, __) => FakeShipServices(/*userStorage: userStorage*/)
          ),
          Provider(create: (_) => GlobalState(
              colorGradient: ColorGradient(colorRamp: colorRamp, step: Factor(0.01)))
          )
        ],
        child: MaterialApp.router(
            title: 'Ship Conquest',
            theme: ThemeData(primarySwatch: Colors.blue),
            routerConfig: createRouter()
        )
    );
  }

}