import 'package:json_annotation/json_annotation.dart';

import '../../model/login_model.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDto {
  const LoginDto({
    required this.email,
    required this.password,
    this.captcha,
  });

  factory LoginDto.fromModel(LoginModel model) {
    return LoginDto(
      email: model.email,
      password: model.password,
      captcha: model.captcha,
    );
  }

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  final String email;
  final String password;
  final String? captcha;
}
