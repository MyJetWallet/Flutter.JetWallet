import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_email_verification_code_request_model.freezed.dart';
part 'send_email_verification_code_request_model.g.dart';

@freezed
class SendEmailVerificationCodeRequestModel with _$SendEmailVerificationCodeRequestModel {
  const factory SendEmailVerificationCodeRequestModel({
    required String language,
    required String deviceType,
  }) = _SendEmailVerificationCodeRequestModel;

  factory SendEmailVerificationCodeRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SendEmailVerificationCodeRequestModelFromJson(json);
}
