import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

@freezed
class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    String? deviceUid,
    String? captcha,
    @JsonKey(name: 'publicKeyPem') required String publicKey,
    required String lang,
    required String email,
    required String password,
    @JsonKey(name: 'application') required int platform,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);
}
