import 'package:json_annotation/json_annotation.dart';

import '../model/authentication_refresh_request_model.dart';

part 'authentication_refresh_request_dto.g.dart';

@JsonSerializable()
class AuthenticationRefreshRequestDto {
  AuthenticationRefreshRequestDto({
    required this.refreshToken,
  });

  factory AuthenticationRefreshRequestDto.fromModel(
    AuthenticationRefreshRequestModel model,
  ) {
    return AuthenticationRefreshRequestDto(
      refreshToken: model.refreshToken,
    );
  }

  Map<String, dynamic> toJson() =>
      _$AuthenticationRefreshRequestDtoToJson(this);

  final String refreshToken;
}
