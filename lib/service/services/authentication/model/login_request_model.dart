import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';

@freezed
class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    required String email,
    required String password,
    String? captcha,
  }) = _LoginRequestModel;
}
