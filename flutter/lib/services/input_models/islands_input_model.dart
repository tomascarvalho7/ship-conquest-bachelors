import 'package:ship_conquest/domain/island/island.dart';

import '../../domain/immutable_collections/sequence.dart';
import 'island_input_model.dart';

class IslandsInputModel {
  final List<IslandInputModel> elements;

  IslandsInputModel.fromJson(Map<String, dynamic> json) :
      elements = List.from(json['islands'])
        .map((e) => IslandInputModel.fromJson(e))
        .toList();
}

extension ToDomain on IslandsInputModel {
  Sequence<Island> toIslandSequence() =>
      Sequence(data: elements.map((e) => e.toIsland()).toList());
}