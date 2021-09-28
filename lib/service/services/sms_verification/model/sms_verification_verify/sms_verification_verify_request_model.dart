import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verification_verify_request_model.freezed.dart';
part 'sms_verification_verify_request_model.g.dart';

@freezed
class SmsVerificationVerifyRequestModel
    with _$SmsVerificationVerifyRequestModel {
  const factory SmsVerificationVerifyRequestModel({
    required String code,
  }) = _SmsVerificationVerifyRequestModel;

  factory SmsVerificationVerifyRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SmsVerificationVerifyRequestModelFromJson(json);
}
