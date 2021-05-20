import 'package:json_annotation/json_annotation.dart';

import '../model/authentication_model.dart';

part 'authentication_dto.g.dart';

@JsonSerializable()
class AuthenticationDto {
  AuthenticationDto({
    required this.token,
    required this.refreshToken,
    required this.tradingUrl,
    required this.connectionTimeOut,
    required this.reconnectTimeOut,
  });

  factory AuthenticationDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationDtoToJson(this);

  AuthenticationModel toModel() {
    return AuthenticationModel(
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
