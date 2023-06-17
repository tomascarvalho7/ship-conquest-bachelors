import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';

/// Pre-defined feedback error, to be used when a token is not found.
const tokenNotFound = ErrorFeedback(
  type: ErrorType.fatal,
  title: "Token not found",
  details: "User Token was not found."
);

/// Pre-defined feedback error, to be used when a lobby is not found.
const lobbyNotFound = ErrorFeedback(
    type: ErrorType.fatal,
    title: "Lobby not found",
    details: "Lobby identifier was not found."
);