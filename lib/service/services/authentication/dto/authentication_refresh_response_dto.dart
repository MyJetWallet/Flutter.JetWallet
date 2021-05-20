import 'package:json_annotation/json_annotation.dart';

import '../model/authentication_refresh_response_model.dart';

part 'authentication_refresh_response_dto.g.dart';

@JsonSerializable()
class AuthenticationRefreshResponseDto {
  AuthenticationRefreshResponseDto({
    required this.token,
    required this.refreshToken,
  });

  factory AuthenticationRefreshResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return _$AuthenticationRefreshResponseDtoFromJson(json);
  }

  AuthenticationRefreshResponseModel toModel() {
    return AuthenticationRefreshResponseModel(
      token: token,
      refreshToken: refreshToken,
    );
  }

  final String token;
  final String refreshToken;
}
