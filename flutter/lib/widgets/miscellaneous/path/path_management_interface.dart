import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/event_handlers/minimap_event.dart';
import 'package:ship_conquest/providers/game/minimap_controllers/route_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/flex_button.dart';

import '../icon_switch.dart';

class PathManagementInterface extends StatelessWidget {
  // constructor
  const PathManagementInterface({super.key});

  @override
  Widget build(BuildContext context) =>
      Container(
          color: const Color.fromRGBO(255, 255, 255, 0.25),
          child: Material(
            child: Consumer<RouteController>(
                builder: (_, pathManager, __) =>
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlexButton(
                            onPressed: () => MinimapEvent.confirm(context),
                            child: IconSwitch(
                                condition: pathManager.routePoints.length > 0,
                                icon: Icons.check,
                                size: 75,
                                enabled: Colors.green,
                                disabled: Colors.grey
                            ),
                          ),
                          FlexButton(
                            onPressed: () => MinimapEvent.cancel(context),
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