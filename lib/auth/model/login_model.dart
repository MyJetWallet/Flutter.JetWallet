import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    required String email,
    required String password,
    String? captcha,
  }) = _RegisterModel;
}
