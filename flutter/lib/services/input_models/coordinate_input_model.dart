class CoordinateInputModel {
  final int x;
  final int y;
  final int z;

  CoordinateInputModel({required this.x, required this.y, required this.z});

  factory CoordinateInputModel.fromJson(Map<String, int> json) {
    final int? x = json['x'];
    final int? y = json['y'];
    final int? z = json['z'];
    if (x == null || y == null || z == null) throw Exception("sdfsdf");
    return CoordinateInputModel(
        x: x,
        y: y,
        z: z);
  }
}
