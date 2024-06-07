import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_email_login_request_model.freezed.dart';
part 'confirm_email_login_request_model.g.dart';

@freezed
class ConfirmEmailLoginRequestModel with _$ConfirmEmailLoginRequestModel {
  const factory ConfirmEmailLoginRequestModel({
    required String verificationToken,
    required String code,
    required String publicKeyPem,
    required String email,
    String? utmSource,
  }) = _ConfirmEmailLoginRequestModel;
  factory ConfirmEmailLoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmEmailLoginRequestModelFromJson(json);
}
