import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/either/future_either.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby/lobby_info.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/domain/user/token.dart';
import 'package:ship_conquest/domain/user/user_info.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/services/google/google_signin_api.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';


/// General static class uses the abroad controllers
/// to execute events from the player's actions.
///
/// These providers are built like independent pieces
/// and the GeneralEvent class combines and uses them together.
class GeneralEvent {

  /// Retrieve the list of lobbies given [skip], [limit], [order], [name] and [filterType].
  static Future<Sequence<LobbyInfo>> getLobbies(BuildContext context, int skip, int limit, String order, String name, String filterType) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobbies response
    return services.getLobbyList(skip, limit, order, name, filterType).fold(
        (left) {
          feedbackController.setError(left);
          return Sequence<LobbyInfo>.empty();
        },
        (right) => right
    );
  }

  /// Set the lobby with tag [tag] as favorite.
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

  /// Remove the lobby with tag [tag] from favorites.
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

  /// Create a lobby with name [name] and execute [onCreation] if the response is successful.
  static void createLobby(BuildContext context, String name, Function(String lid) onCreation) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle lobby creation response
    services.createLobby(name).either(
            (left) => feedbackController.setError(left),
            (right) => onCreation(right.tag)
    );
  }

  /// Join a lobby with tag [tag] and execute [onJoining] if the response is successful.
  static void joinLobby(BuildContext context, String tag, Function(String lid) onJoining) {
    // get controller's
    final services = context.read<ShipServices>();
    final feedbackController = context.read<FeedbackController>();
    // handle joining lobby response
    services.joinLobby(tag).either(
            (left) => feedbackController.setError(left),
            (right) => onJoining(right.tag)
    );
  }

  /// Get the full information of a user and execute [onUserInfo] if the response is successful.
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

  /// Sign the user in and execute [onToken] if the response is successful.
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

  /// Log the user in and execute [onToken] if the response is successful.
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

  /// Get the patch notes and execute [onPatchNotes] if the response is successful.
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