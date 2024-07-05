import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_verification_code_request_model.freezed.dart';
part 'verify_email_verification_code_request_model.g.dart';

@freezed
class VerifyEmailVerificationCodeRequestModel with _$VerifyEmailVerificationCodeRequestModel {
  const factory VerifyEmailVerificationCodeRequestModel({
    required String code,
  }) = _VerifyEmailVerificationCodeRequestModel;

  factory VerifyEmailVerificationCodeRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$VerifyEmailVerificationCodeRequestModelFromJson(json);
}
