class CoordinateInputModel {
  final int x;
  final int y;
  final int z;

  CoordinateInputModel({required this.x, required this.y, required this.z});

  CoordinateInputModel.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'];
}
