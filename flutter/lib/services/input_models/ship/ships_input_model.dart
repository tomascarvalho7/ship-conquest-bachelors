import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/ship/ship.dart';
import 'package:ship_conquest/services/input_models/ship/ship_input_model.dart';

/// Input model class representing input data for a list of ships.
class ShipsInputModel {
  final List<ShipInputModel> ships;

  // Constructor to deserialize the input model from a JSON map.
  ShipsInputModel.fromJson(Map<String, dynamic> json) :
      ships =  List<dynamic>.from(json['ships'])
          .map((e) => ShipInputModel.fromJson(e))
          .toList();
}

// An extension on the [ShipsInputModel] class to convert it to an [Sequence<Ship>] domain object.
extension ToDomain on ShipsInputModel {
  /// Converts the [ShipsInputModel] to a [Sequence<Ship>] object.
  Sequence<Ship> toSequenceOfShips() =>
      Sequence(data: ships.map((e) => e.toShip()).toList());
}