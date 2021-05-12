import 'package:json_annotation/json_annotation.dart';

import 'auth_dto.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  AuthResponseDto({
    required this.result,
    required this.data,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  final int result;
  final AuthDto data;
}
