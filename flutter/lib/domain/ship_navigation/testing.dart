import 'dart:io';

import 'package:ship_conquest/domain/ship_navigation/find_middle_points.dart';
import 'package:ship_conquest/domain/ship_navigation/find_path.dart';
import 'package:ship_conquest/domain/space/map_position.dart';

void main() {
  final List<MapPosition> testMap = generateSquare(10, 11, 10) + generateSquare(10, 21, 10) + generateSquare(19, 1, 10) + generateSquare(2, 31, 10) + generateSquare(2, 31, 5);

  const MapPosition start = MapPosition(x: 0, y: 0);
  const MapPosition end = MapPosition(x: 69, y: 69);
  const MapPosition influencePoint = MapPosition(x: 0, y: 69);

  final List<MapPosition> shortestPath = findShortestPath(testMap, start, end, influencePoint, 1, 70);
  final List<MapPosition> middlePoints = defineMiddlePoints(shortestPath, 10);

  printGrid(shortestPath, testMap, middlePoints, start, end, influencePoint, 70);
}


List<MapPosition> generateSquare(int x, int y, int size) {
  List<MapPosition> positions = List.empty(growable: true);
  for(int i = 0; i < size; i++) {
    for(int j = 0; j < size; j++) {
      final int newX = x + i;
      final int newY = y + j;
      positions.add(MapPosition(x: newX, y: newY));
    }
  }
  return positions;
}

void printGrid(List<MapPosition> path, List<MapPosition> barriers, List<MapPosition> middlePoints, MapPosition start,
    MapPosition end, MapPosition influencePoint, int mapSize) {
  var grid = List.generate(mapSize, (_) => List.filled(mapSize, '_'));

  for (var position in path) {
    grid[position.y][position.x] = 'P';
  }
  for (var position in barriers) {
    grid[position.y][position.x] = 'B';
  }
  grid[start.y][start.x] = 'S';
  grid[end.y][end.x] = 'E';
  grid[influencePoint.y][influencePoint.x] = 'I';
  for (var position in middlePoints) {
    grid[position.y][position.x] = 'M';
  }

  for (var i = 0; i < mapSize; i++) {
    for (var j = 0; j < mapSize; j++) {
      var symbol = isSingleLetter(grid[i][j]) ? ' ${grid[i][j]} ' : ' _ ';
      stdout.write(symbol);
    }
    print('');
  }
}

bool isSingleLetter(String s) {
  return s.length == 1 && s.contains(RegExp(r'[a-zA-Z]'));
}