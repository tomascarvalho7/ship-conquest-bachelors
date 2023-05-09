import 'package:ship_conquest/domain/user/token.dart';

class TokenInputModel {
  final String value;

  TokenInputModel.fromJson(Map<String, dynamic> json)
    : value = json['token'];
}

extension Convert on TokenInputModel {
  Token toToken() => Token(token: value);
}