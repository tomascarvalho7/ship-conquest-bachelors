/// Input model class representing input data for 3D coordinate with integer properties.
class CoordinateInputModel {
  final int x;
  final int y;
  final int z;

  CoordinateInputModel({required this.x, required this.y, required this.z});

  // Constructor to deserialize the input model from a JSON map.
  CoordinateInputModel.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'];
}
