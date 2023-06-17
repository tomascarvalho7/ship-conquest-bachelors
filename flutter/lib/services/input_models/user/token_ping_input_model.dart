import 'package:ship_conquest/domain/user/token_ping.dart';

/// Input model class representing input data for token authentication ping.
class TokenPingInputModel {
  final String value;

  // Constructor to deserialize the input model from a JSON map.
  TokenPingInputModel.fromJson(Map<String, dynamic> json)
      : value = json['result'];
}

// An extension on the [TokenPingInputModel] class to convert it to an [TokenPing] domain object.
extension Convert on TokenPingInputModel {
  /// Converts the [TokenPingInputModel] to a [TokenPing] object.
  TokenPing toTokenPing() => TokenPing(result: value);
}