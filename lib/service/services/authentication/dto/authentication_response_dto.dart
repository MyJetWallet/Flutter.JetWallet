import 'package:json_annotation/json_annotation.dart';

import 'authentication_dto.dart';

part 'authentication_response_dto.g.dart';

@JsonSerializable()
class AuthenticationResponseDto {
  AuthenticationResponseDto({
    required this.result,
    required this.authDto,
  });

  factory AuthenticationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseDtoFromJson(json);

  final int result;
  @JsonKey(name: 'data')
  final AuthenticationDto authDto;
}
