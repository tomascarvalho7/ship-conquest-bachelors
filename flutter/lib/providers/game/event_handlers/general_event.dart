import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/lobby.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/immutable_collections/sequence.dart';
import '../../../domain/user/user_info.dart';

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

  static void getPersonalInfo(BuildContext context, Function(UserInfo info) onUserInfo) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle user profile response
    services.getPersonalInfo().either(
            (left) => feedbackController.setError(left),
            (right) => onUserInfo(right)
    );
  }

  static void getPatchNotes(BuildContext context, Function(PatchNotes notes) onPatchNotes) {
    // change from string to path notes domain class
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle user profile response
    /*services.getPatchNotes().either(
            (left) => feedbackController.setError(left),
            (right) => onPatchNotes(right)
    );*/
    onPatchNotes(PatchNotes(notes: ["Combat Update!"]));
  }
}