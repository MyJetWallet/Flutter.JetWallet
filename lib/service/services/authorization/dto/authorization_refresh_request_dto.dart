import 'package:json_annotation/json_annotation.dart';

import '../model/authorization_refresh_request_model.dart';

part 'authorization_refresh_request_dto.g.dart';

@JsonSerializable()
class AuthorizationRefreshRequestDto {
  AuthorizationRefreshRequestDto({
    this.signature,
    required this.token,
    required this.requestTime,
  });

  factory AuthorizationRefreshRequestDto.fromModel(
      AuthorizationRefreshRequestModel model) {
    return AuthorizationRefreshRequestDto(
      token: model.token,
      signature: model.signature,
      requestTime: model.requestTime,
    );
  }

  Map<String, dynamic> toJson() => _$AuthorizationRefreshRequestDtoToJson(this);

  final String? signature;
  final String token;
  final String requestTime;
}
