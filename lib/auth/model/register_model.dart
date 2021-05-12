import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_model.freezed.dart';

@freezed
class RegisterModel with _$RegisterModel {
  const factory RegisterModel({
    required String email,
    required String password,
    String? captcha,
    String? phone,
  }) = _RegisterModel;
}
