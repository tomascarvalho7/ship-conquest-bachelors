import 'package:ship_conquest/domain/space/cubic_bezier.dart';
import 'package:ship_conquest/services/input_models/coord_2d_input_model.dart';

class CubicBezierInputModel {
  final Coord2DInputModel p0;
  final Coord2DInputModel p1;
  final Coord2DInputModel p2;
  final Coord2DInputModel p3;

  CubicBezierInputModel(
      {required this.p0, required this.p1, required this.p2, required this.p3});

  CubicBezierInputModel.fromJson(Map<String, dynamic> json)
      : p0 = Coord2DInputModel.fromJson(json['p0']),
        p1 = Coord2DInputModel.fromJson(json['p1']),
        p2 = Coord2DInputModel.fromJson(json['p2']),
        p3 = Coord2DInputModel.fromJson(json['p3']);
}

extension ConvertList on List<CubicBezierInputModel> {
  List<CubicBezier> toCubicBezierList() =>
      map((inputModel) =>
          CubicBezier(p0: inputModel.p0.toCoord2D(),
              p1: inputModel.p1.toCoord2D(),
              p2: inputModel.p2.toCoord2D(),
              p3: inputModel.p3.toCoord2D())).toList();

}

extension Convert on CubicBezierInputModel {
  CubicBezier toCubicBezier() =>
      CubicBezier(p0: p0.toCoord2D(),
          p1: p1.toCoord2D(),
          p2: p2.toCoord2D(),
          p3: p3.toCoord2D());
}