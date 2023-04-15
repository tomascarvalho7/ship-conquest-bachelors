import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:ship_conquest/domain/minimap.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

import 'find_middle_points.dart';
import 'find_path.dart';
/*
void main2(Coord2D start, Coord2D end, Coord2D influencePoint, Minimap minimap) async {
  final hMap = HashMap<Coord2D, Color>();

  final List<Coord2D> shortestPath = findShortestPath(minimap, start, end, influencePoint, 1);
  final List<Coord2D> middlePoints = defineMiddlePoints(shortestPath, 10);

  printGrid(shortestPath, middlePoints, start, end, influencePoint, 70);
}
List<Coord2D> generateSquare2(int x, int y, int size) {
  List<Coord2D> positions = List.empty(growable: true);
  for(int i = 0; i < size; i++) {
    for(int j = 0; j < size; j++) {
      final int newX = x + i;
      final int newY = y + j;
      positions.add(Coord2D(x: newX, y: newY));
    }
  }
  return positions;
}

HashMap<Coord2D, Color> generateSquare(int x, int y, int size, HashMap<Coord2D, Color> map) {
  for(int i = 0; i < size; i++) {
    for(int j = 0; j < size; j++) {
      final int newX = x + i;
      final int newY = y + j;
      map.putIfAbsent(Coord2D(x: newX, y: newY), () => const Color.fromRGBO(0,0,0,0));
    }
  }
  return map;
}

void printGrid(List<Coord2D> path,/* List<Position> barriers*/ List<Coord2D> middlePoints, Coord2D start,
    Coord2D end, Coord2D influencePoint, int mapSize) {
  var grid = List.generate(mapSize, (_) => List.filled(mapSize, '_'));

  for (var position in path) {
    grid[position.y][position.x] = 'P';
  }
  /*for (var position in barriers) {
    grid[position.y.toInt()][position.x.toInt()] = 'B';
  }*/
  grid[start.y][start.x] = 'S';
  grid[end.y][end.x] = 'E';
  grid[influencePoint.y][influencePoint.x] = 'I';
  for (var position in middlePoints) {
    grid[position.y][position.x] = 'M';
  }

  for (var i = 0; i < mapSize; i++) {
    var finalString = "";
    for (var j = 0; j < mapSize; j++) {
      var symbol = isSingleLetter(grid[i][j]) ? ' ${grid[i][j]} ' : ' _ ';
      finalString += symbol;
    }
    print(finalString);
  }
}

bool isSingleLetter(String s) {
  return s.length == 1 && s.contains(RegExp(r'[a-zA-Z]'));
}
*/