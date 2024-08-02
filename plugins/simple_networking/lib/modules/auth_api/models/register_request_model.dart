import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';
part 'register_request_model.g.dart';

@freezed
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    String? deviceUid,
    String? captcha,
    String? phone,
    String? referralCode,
    bool? marketingEmailsAllowed,
    @JsonKey(name: 'publicKeyPem') required String publicKey,
    required String lang,
    required String email,
    required String password,
    required int platformType,
    @JsonKey(name: 'application') required int platform,
  }) = _RegisterRequestModel;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);
}
