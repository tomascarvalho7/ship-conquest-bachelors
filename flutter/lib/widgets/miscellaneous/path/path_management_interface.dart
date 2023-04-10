import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/route_manager.dart';

class PathManagementInterface extends StatelessWidget {
  const PathManagementInterface({super.key});

  @override
  Widget build(BuildContext context) =>
      Material(
        child: Consumer<RouteManager>(
            builder: (_, pathManager, __) =>
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 75,
                          onPressed: () => pathManager.confirm(),
                          isSelected: pathManager.pathPoints != null,
                          icon: const Icon(Icons.check, color: Colors.grey),
                          selectedIcon: const Icon(Icons.check, color: Colors.red),
                      ),
                      IconButton(
                          iconSize: 75,
                          onPressed: () => pathManager.cancel(),
                          color: Colors.red,
                          disabledColor: Colors.grey,
                          isSelected: pathManager.pathPoints != null,
                          icon: const Icon(Icons.close)
                      )
                    ]
                )
        ),
      );


  void onPressed(int index, RouteManager pathManager) {
    if (index == 0) {
      pathManager.confirm();
    } else {
      pathManager.cancel();
    }
  }
}