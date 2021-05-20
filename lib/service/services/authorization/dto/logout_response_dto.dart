import 'package:json_annotation/json_annotation.dart';

part 'logout_response_dto.g.dart';

@JsonSerializable()
class LogoutResponseDto {
  LogoutResponseDto({
    required this.result,
  });

  factory LogoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseDtoFromJson(json);

  final String result;
}
