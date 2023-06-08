class ErrorFeedback {
  final ErrorType type;
  final String title;
  final String details;

  ErrorFeedback({required this.type, required this.title, required this.details});
}

enum ErrorType {
  fatal,
  info
}