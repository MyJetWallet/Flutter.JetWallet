import 'package:json_annotation/json_annotation.dart';

import '../../../shared/dto/reponse_codes_dto.dart';
import '../model/authorization_response_model.dart';

part 'authorization_response_dto.g.dart';

@JsonSerializable()
class AuthorizationResponseDto {
  AuthorizationResponseDto({
    required this.responseCodes,
    required this.token,
  });

  factory AuthorizationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationResponseDtoFromJson(json);

  AuthorizationResponseModel toModel() {
    return AuthorizationResponseModel(
      token: token,
    );
  }

  @JsonKey(name: 'result')
  final ResponseCodesDto responseCodes;
  @JsonKey(name: 'data')
  final String token;
}
