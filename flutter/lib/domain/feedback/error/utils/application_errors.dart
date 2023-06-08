import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';

const tokenNotFound = ErrorFeedback(
  type: ErrorType.fatal,
  title: "Token not found",
  details: "User Token was not found."
);

const lobbyNotFound = ErrorFeedback(
    type: ErrorType.fatal,
    title: "Lobby not found",
    details: "Lobby identifier was not found."
);