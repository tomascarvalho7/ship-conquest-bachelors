import 'package:ship_conquest/domain/user/token.dart';

import '../../domain/user/token_ping.dart';

class TokenPingInputModel {
  final String value;

  TokenPingInputModel.fromJson(Map<String, dynamic> json)
      : value = json['result'];
}

extension Convert on TokenPingInputModel {
  TokenPing toTokenPing() => TokenPing(result: value);
}