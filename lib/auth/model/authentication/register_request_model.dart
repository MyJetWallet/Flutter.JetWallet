import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';

@freezed
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String email,
    required String password,
    String? captcha,
    String? phone,
  }) = _RegisterRequestModel;
}
