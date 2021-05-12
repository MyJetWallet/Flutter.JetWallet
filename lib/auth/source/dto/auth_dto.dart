import 'package:json_annotation/json_annotation.dart';

import '../../model/auth_model.dart';

part 'auth_dto.g.dart';

@JsonSerializable()
class AuthDto {
  AuthDto({
    required this.token,
    required this.refreshToken,
    required this.tradingUrl,
    required this.connectionTimeOut,
    required this.reconnectTimeOut,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) =>
      _$AuthDtoFromJson(json);

  AuthModel toModel() {
    return AuthModel(
      token: token,
      refreshToken: refreshToken,
      tradingUrl: tradingUrl,
      connectionTimeOut: connectionTimeOut,
      reconnectTimeOut: reconnectTimeOut,
    );
  }

  final String token;
  final String refreshToken;
  final String tradingUrl;
  final String connectionTimeOut;
  final String reconnectTimeOut;
}
