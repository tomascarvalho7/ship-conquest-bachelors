import 'package:ship_conquest/domain/immutable_collections/grid.dart';
import 'package:ship_conquest/domain/space/coord_2d.dart';

///
/// The [Minimap] class is an mutable [Grid] that
/// stores the visited [Voxel] data.
///
/// The [Data Structure] of the stored Voxels is:
/// Key: [Coord2D] to store the Voxel position the X and Y axis.
/// Value: [int] to store the Voxel height.
///
/// Notes: The height is stored as a integer, because it can
/// only be whole numbers.
///
class Minimap {
  final int length;
  Grid<Coord2D, int> data;

  Minimap({required this.length, required this.data});

  void add({required int x, required int y, required int height})
    => data = data.put(Coord2D(x: x, y: y), height);

  int? get({required int x, required int y}) => data.getOrNull(Coord2D(x: x, y: y));
}