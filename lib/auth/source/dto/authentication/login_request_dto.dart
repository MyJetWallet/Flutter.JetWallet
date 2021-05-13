import 'package:json_annotation/json_annotation.dart';

import '../../../model/authentication/login_request_model.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto {
  const LoginRequestDto({
    required this.email,
    required this.password,
    this.captcha,
  });

  factory LoginRequestDto.fromModel(LoginRequestModel model) {
    return LoginRequestDto(
      email: model.email,
      password: model.password,
      captcha: model.captcha,
    );
  }

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);

  final String email;
  final String password;
  final String? captcha;
}
