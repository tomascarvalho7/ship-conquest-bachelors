import 'coordinate.dart';

class Chunk {
  // Coordinates
  final int size;
  final Coordinate coordinates;
  final List<Coordinate> tiles;
  Chunk({required this.size, required this.coordinates, required this.tiles});
}

