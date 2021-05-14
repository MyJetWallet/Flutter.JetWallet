import 'package:json_annotation/json_annotation.dart';

import '../../model/authentication/register_request_model.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  const RegisterRequestDto({
    required this.email,
    required this.password,
    this.captcha,
    this.phone,
  });

  factory RegisterRequestDto.fromModel(RegisterRequestModel model) {
    return RegisterRequestDto(
      email: model.email,
      password: model.password,
      captcha: model.captcha,
      phone: model.phone,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);

  final String email;
  final String password;
  final String? captcha;
  final String? phone;
}
