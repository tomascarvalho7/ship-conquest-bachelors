import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/ship/ship_path.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';
import 'package:ship_conquest/domain/space/position.dart';
import 'package:ship_conquest/domain/space/coordinate.dart';
import 'package:ship_conquest/domain/token.dart';
import 'package:ship_conquest/domain/utils/build_bezier.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/input_models/chunk_input_model.dart';
import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';
import 'package:ship_conquest/services/input_models/cubic_bezier_input_model.dart';
import 'package:ship_conquest/services/input_models/minimap_input_model.dart';
import 'package:ship_conquest/services/input_models/ship_path_time_input_model.dart';
import 'package:ship_conquest/services/input_models/token_input_model.dart';
import 'package:ship_conquest/services/output_models/coord_2d_output_model.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:http/http.dart' as http;

import '../../domain/tile/tile_list.dart';
import '../input_models/ship_path_input_model.dart';

const baseUri = "e239-46-189-174-32.ngrok-free.app";
const lobbyId = "018UtX";

class RealShipServices extends ShipServices {
  final UserStorage userStorage;

  RealShipServices({required this.userStorage});

  @override
  Future<TileList> getNewChunk(int chunkSize, Coord2D coordinates) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");


    final response = await http.get(
        Uri.https(baseUri, "$lobbyId/view", {'shipId': '1'}), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final res = ChunkInputModel.fromJson(jsonDecode(response.body));
      final resTiles = res.tiles.map((e) {
        return Coordinate(x: e.x, y: e.y, z: e.z);
      }).toList();

      return TileList(tiles: resTiles);
    } else {
      throw Exception("error fetching a new chunk");
    }
  }

  @override
  Future<Token> signIn(String idToken) async {
    final response = await http.post(
        Uri.https(baseUri, "get-token"),
        headers: { "Content-Type": "application/x-www-form-urlencoded"},
        body: "idtoken=$idToken"
    );

    if (response.statusCode == 200) {
      final res = TokenInputModel.fromJson(jsonDecode(response.body));
      return res.toToken();
    } else {
      throw Exception("error creating user token");
    }
  }

  @override
  Future<Minimap> getMinimap(ColorGradient colorGradient) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final response =
    await http.get(Uri.https(baseUri, "$lobbyId/minimap"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final res = MinimapInputModel.fromJson(jsonDecode(response.body));

      final minimap =
      Minimap(length: res.length, pixels: HashMap<Coord2D, Color>());
      for (var point in res.points) {
        if (minimap.pixels[Coord2D(x: point.x, y: point.y)] == null) {
          minimap.add(
              x: point.x, y: point.y, color: colorGradient.get(point.z));
        }
      }
      List<Coord2D> visitedPoints = res.points
          .where((point) => point.z == 0)
          .map((coord) => Coord2D(x: coord.x, y: coord.y))
          .toList();

      return addWaterPath(minimap, colorGradient, visitedPoints, 15);
    } else {
      throw Exception("error fetching minimap");
    }
  }

  @override
  Future<ShipPath> navigateTo(int sId, List<Coord2D> landmarks) async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    Map<String, dynamic> jsonBody = {
      'points': landmarks.map((coord) => Coord2DOutputModel(x: coord.x, y: coord.y).toJson()).toList(),
    };

    final response = await http.post(
        Uri.https(baseUri, "$lobbyId/navigate", {'shipId': '1'}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(jsonBody)
    );

    if (response.statusCode == 200) {
      final res = ShipPathTimeInputModel.fromJson(jsonDecode(response.body));

      return ShipPath(landmarks: buildBeziers(landmarks),
          startTime: res.startTime,
          duration: res.duration);
    } else {
      throw Exception("error navigating with ship");
    }
  }

  @override
  Future<Object?> getMainShipLocation() async {
    final String? token = await userStorage.getToken();
    if (token == null) throw Exception("couldn't find token");

    final response = await http.get(
        Uri.https(baseUri, "$lobbyId/ship/location", {'shipId': '1'}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        }
    );

    if (response.statusCode == 200) {
      final res = ShipPathInputModel.fromJson(jsonDecode(response.body));
      final startTime = res.startTime;
      final duration = res.duration;


      if(res.landmarks.length == 1) {
          return Position(x: res.landmarks.first.x.toDouble(), y: res.landmarks.first.y.toDouble());
      } else if(startTime != null && duration != null){
          return ShipPath(landmarks: buildBeziers(res.landmarks.map((coord) => Coord2D(x: coord.x, y: coord.y)).toList()),
              startTime: startTime,
              duration: duration);
      }

    } else if(response.statusCode == 404) {
      return null;
    } else {
      throw Exception("error navigating with ship");
    }
  }
}

double calcDistance(Coord2D p1, Coord2D p2) {
  return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

Minimap addWaterPath(Minimap minimap, ColorGradient colorGradient,
    List<Coord2D> visitedPoints, int radius) {
  List<Coord2D> points = [];
  if(visitedPoints.length == 1) {
    return pulseAndFill(minimap, visitedPoints.first, radius, colorGradient.get(0));
  }
  for (int idx = 0; idx < visitedPoints.length; idx++) {
    final currPoint = visitedPoints[idx];
    if (idx + 1 < visitedPoints.length) {
      final nextPoint = visitedPoints[idx + 1];
      final phi = atan((nextPoint.y - currPoint.y) /
          (nextPoint.x - currPoint.x)); // rotation angle of the ellipse
      double distance = calcDistance(
          currPoint, nextPoint); //distance between focus points
      final a = distance + (2 * radius); // major
      final b = 2 * radius; //minor

      double h = (currPoint.x + nextPoint.x) / 2; // center x
      double k = (currPoint.y + nextPoint.y) / 2; // center y

      for (double t = 0; t < 2 * pi; t += 0.1) {
        double x = h + a * cos(t) * cos(phi) - b * sin(t) * sin(phi);
        double y = k + a * cos(t) * sin(phi) + b * sin(t) * cos(phi);

        points.add(Coord2D(x: x.floor(), y: y.floor()));
      }
      minimap = fillEllipse(
          points, minimap, colorGradient.get(0), [currPoint, nextPoint], a);
    }
  }
  return minimap;
}

Minimap fillEllipse(List<Coord2D> points, Minimap minimap, Color color,
    List<Coord2D> focusPoints, double major) {
  // find the ellipse's bounding box
  int minX = points.map((p) => p.x).reduce(min);
  int maxX = points.map((p) => p.x).reduce(max);
  int minY = points.map((p) => p.y).reduce(min);
  int maxY = points.map((p) => p.y).reduce(max);

  // iterate in the ellipse's bounding box and add the tiles that are inside the ellipse
  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      final currCoord = Coord2D(x: x, y: y);
      if (isInsideEllipse(currCoord, focusPoints, major) &&
          minimap.pixels[currCoord] == null
      ) {
        minimap.add(x: x, y: y, color: color);
      }
    }
  }
  return minimap;
}

bool isInsideEllipse(Coord2D point, List<Coord2D> focusPoints, double a) {
  // in an ellipse, the sum of distances of every point to the focus points is less than the semimajor
  double l1 = calcDistance(point, focusPoints[0]);
  double l2 = calcDistance(point, focusPoints[1]);
  return l1 + l2 <= a;
}

Minimap pulseAndFill(Minimap minimap, Coord2D center, int radius, Color color) {
  for (var y = -radius; y <= radius; y++) {
    final yF = y.toDouble();
    for (var x = -radius; x <= radius; x++) {
      final xF = x.toDouble();
      final distance = sqrt(pow(xF, 2) + pow(yF, 2));

      if (radius / distance >= 0.95) {
        final pos = center + Coord2D(x: x, y: y);

        if (minimap.get(x: pos.x, y: pos.y) == null) {
          minimap.add(x: pos.x, y: pos.y, color: color);
        }
      }
    }
  }
  return minimap;
}