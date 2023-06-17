import 'package:ship_conquest/domain/user/token.dart';

/// Input model class representing input data of a token.
class TokenInputModel {
  final String value;

  // Constructor to deserialize the input model from a JSON map.
  TokenInputModel.fromJson(Map<String, dynamic> json)
    : value = json['token'];
}

// An extension on the [TokenInputModel] class to convert it to an [Token] domain object.
extension Convert on TokenInputModel {
  /// Converts the [TokenInputModel] to a [Token] object.
  Token toToken() => Token(token: value);
}