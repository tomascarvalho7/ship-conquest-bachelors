import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/lobby.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/immutable_collections/sequence.dart';

class GeneralEvent {
  static Future<Sequence<Lobby>> getLobbies(BuildContext context, int skip, int limit, String order, String query) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobbies response
    return services.getLobbyList(skip, limit, order, query).fold(
        (left) {
          feedbackController.setError(left);
          return Sequence<Lobby>.empty();
        },
        (right) => right
    );
  }

  static void createLobby(BuildContext context, String name, Function(String lid) onCreation) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobby creation response
    services.createLobby(name).either(
            (left) => feedbackController.setError(left),
            (right) => onCreation(right)
    );
  }

  static void joinLobby(BuildContext context, String tag, Function(String lid) onJoining) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle joining lobby response
    services.joinLobby(tag).either(
            (left) => feedbackController.setError(left),
            (right) => onJoining(right)
    );
  }
}