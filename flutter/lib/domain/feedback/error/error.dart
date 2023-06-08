import 'package:ship_conquest/domain/feedback/error/error_type.dart';

class Error {
  final ErrorType type;
  final String title;
  final String details;

  Error({required this.type, required this.title, required this.details});
}