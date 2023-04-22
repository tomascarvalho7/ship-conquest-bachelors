import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';
import 'package:ship_conquest/widgets/miscellaneous/flex_button.dart';
import 'package:ship_conquest/widgets/screens/minimap/events/minimap_event.dart';

import '../icon_switch.dart';

class PathManagementInterface extends StatelessWidget {
  final MinimapEvent eventHandler;
  // constructor
  const PathManagementInterface({super.key, required this.eventHandler});

  @override
  Widget build(BuildContext context) =>
      Container(
          color: const Color.fromRGBO(255, 255, 255, 0.25),
          child: Material(
            child: Consumer<RouteManager>(
                builder: (_, pathManager, __) =>
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlexButton(
                            onPressed: () => eventHandler.confirm(),
                            child: IconSwitch(
                                condition: pathManager.routePoints.isNotEmpty,
                                icon: Icons.check,
                                size: 75,
                                enabled: Colors.green,
                                disabled: Colors.grey
                            ),
                          ),
                          FlexButton(
                            onPressed: () => eventHandler.cancel(),
                            child: IconSwitch(
                                condition: pathManager.pathPoints != null,
                                icon: Icons.close,
                                size: 75,
                                enabled: Colors.red,
                                disabled: Colors.grey
                            ),
                          )
                        ]
                    )
            ),
          )
      );
}