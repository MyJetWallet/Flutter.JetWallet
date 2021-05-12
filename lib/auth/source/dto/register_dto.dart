import 'package:json_annotation/json_annotation.dart';

import '../../model/register_model.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto {
  const RegisterDto({
    required this.email,
    required this.password,
    this.captcha,
    this.phone,
  });

  factory RegisterDto.fromModel(RegisterModel model) {
    return RegisterDto(
      email: model.email,
      password: model.password,
      captcha: model.captcha,
      phone: model.phone,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  final String email;
  final String password;
  final String? captcha;
  final String? phone;
}
