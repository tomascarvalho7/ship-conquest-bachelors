import 'package:ship_conquest/domain/space/coord_2d.dart';

class NavigationPathOutputModel {
  final Coord2D start;
  final Coord2D mid;
  final Coord2D end;
  // constructor
  NavigationPathOutputModel({required this.start, required this.mid, required this.end});

  Map<String, dynamic> toJson() =>
      {
        'start': {'x': start.x, 'y': start.y},
        'mid': {'x': mid.x, 'y': mid.y},
        'end': {'x': end.x, 'y': end.y}
      };
}