
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/providers/tile_manager.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../providers/camera.dart';
import '../providers/minimap_provider.dart';
import 'color_gradient.dart';

class GameEvent {
  final Camera camera;
  final TileManager tileManager;
  final MinimapProvider minimapProvider;
  final ColorGradient colorGradient;
  // constructor
  GameEvent({
    required this.camera,
    required this.tileManager,
    required this.minimapProvider,
    required this.colorGradient
  });

  // load initial data
  void load(ShipServices services)  {
    services.getMinimap(Token(token: 'TODO')).then(
            (minimap) {
              minimapProvider.init(minimap);
              lookAround(services);
            }
    );
  }

  // look around for new tiles
  void lookAround(ShipServices services) async {
    bool looked = await tileManager.lookForTiles(camera.centerCoordinates / camera.scaleFactor, services);
    // if new tiles were found, add them to minimap
    if (looked) {
      minimapProvider.update(tileManager.tiles, colorGradient);
    }
  }
}