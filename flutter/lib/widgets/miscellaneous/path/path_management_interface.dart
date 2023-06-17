import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/event_handlers/minimap_event.dart';
import 'package:ship_conquest/providers/game/minimap_controllers/route_controller.dart';
import 'package:ship_conquest/widgets/miscellaneous/flex_button.dart';
import 'package:ship_conquest/widgets/miscellaneous/icon_switch.dart';

/// Widget to manage the paths in the minimap widget
///
/// Presents the actions:
/// - [Confirm and navigate]
/// - [Cancel]
class PathManagementInterface extends StatelessWidget {
  // constructor
  const PathManagementInterface({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer<RouteController>(
          builder: (_, pathManager, __) =>
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlexButton(
                        onPressed: () => MinimapEvent.confirmAndNavigateTo(context),
                        child: IconSwitch(
                            condition: pathManager.routePoints.isNotEmpty,
                            icon: Icons.check,
                            size: 60,
                            enabled: Colors.green,
                            disabled: Colors.grey
                        ),
                      ),
                    FlexButton(
                      onPressed: () => MinimapEvent.cancel(context),
                      child: IconSwitch(
                          condition: pathManager.pathPoints != null,
                          icon: Icons.close,
                          size: 60,
                          enabled: Colors.red,
                          disabled: Colors.grey
                      ),
                    )
                  ]
              )
      );
}