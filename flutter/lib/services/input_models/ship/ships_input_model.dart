import 'package:ship_conquest/services/input_models/ship/ship_input_model.dart';

import '../../../domain/ship/ship.dart';
import '../../../domain/immutable_collections/sequence.dart';

class ShipsInputModel {
  final List<ShipInputModel> ships;

  ShipsInputModel.fromJson(Map<String, dynamic> json) :
      ships =  List<dynamic>.from(json['ships'])
          .map((e) => ShipInputModel.fromJson(e))
          .toList();
}

extension ToDomain on ShipsInputModel {
  Sequence<Ship> toSequenceOfShips() =>
      Sequence(data: ships.map((e) => e.toShip()).toList());
}