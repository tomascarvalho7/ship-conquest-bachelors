import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/island/island.dart';
import 'package:ship_conquest/services/input_models/game/island_input_model.dart';

/// Input model class representing input data for a list of islands.
class IslandsInputModel {
  final List<IslandInputModel> elements;

  // Constructor to deserialize the input model from a JSON map.
  IslandsInputModel.fromJson(Map<String, dynamic> json) :
      elements = List.from(json['islands'])
        .map((e) => IslandInputModel.fromJson(e))
        .toList();
}

// An extension on the [IslandsInputModel] class to convert it to an [Sequence<Island>] object.
extension ToDomain on IslandsInputModel {
  /// Converts the [IslandsInputModel] to a [Sequence<Island>] object.
  Sequence<Island> toIslandSequence() =>
      Sequence(data: elements.map((e) => e.toIsland()).toList());
}