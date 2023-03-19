import 'package:ship_conquest/domain/token.dart';

class TokenInputModel {
  final String value;

  TokenInputModel.fromJson(Map<String, dynamic> json)
    : value = json['value'];
}

extension Convert on TokenInputModel {
  Token toToken() => Token(token: value);
}