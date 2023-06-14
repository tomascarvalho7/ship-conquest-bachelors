import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';

import '../../../domain/immutable_collections/sequence.dart';
import '../../../domain/user/token.dart';
import '../../../domain/user/user_info.dart';
import '../../../services/google/google_signin_api.dart';

/// General static class uses the abroad controllers
/// to execute events from the player's actions.
///
/// These providers are built like independent pieces
/// and the GeneralEvent class combines and uses them together.
class GeneralEvent {
  static Future<Sequence<CompleteLobby>> getLobbies(BuildContext context, int skip, int limit, String order, String name, String filterType) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobbies response
    return services.getLobbyList(skip, limit, order, name, filterType).fold(
        (left) {
          feedbackController.setError(left);
          return Sequence<CompleteLobby>.empty();
        },
        (right) => right
    );
  }

  static Future<void> setFavoriteLobby(BuildContext context, String tag) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobbies response
    return services.setFavoriteLobby(tag).fold(
            (left) {
          feedbackController.setError(left);
        },
            (right) => right
    );
  }

  static Future<void> removeFavoriteLobby(BuildContext context, String tag) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobbies response
    return services.removeFavoriteLobby(tag).fold(
            (left) {
          feedbackController.setError(left);
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

  static void signIn(BuildContext context, String username, String description, Function(Token token) onToken) async {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // make authentication requests
    final account = await GoogleSignInApi.login();
    final userInfo = await GoogleSignInApi.getUserInfo(account!);
    services.signIn(userInfo, username, description).either(
            (left) {
              feedbackController.setError(left);
              GoogleSignInApi.logout();
              },
            (right) => onToken(right)
    );
  }

  static void login(BuildContext context, Function(Token token) onToken) async {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // make authentication requests
    final account = await GoogleSignInApi.login();
    final userInfo = await GoogleSignInApi.getUserInfo(account!);
    services.logIn(userInfo).either(
            (left) {
              feedbackController.setError(left);
              GoogleSignInApi.logout();
            },
            (right) => onToken(right)
    );
  }

  static void getPatchNotes(BuildContext context, Function(PatchNotes notes) onPatchNotes) {
    // change from string to path notes domain class
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle user profile response
    services.getPatchNotes().either(
            (left) => feedbackController.setError(left),
            (right) => onPatchNotes(right)
    );
  }
}