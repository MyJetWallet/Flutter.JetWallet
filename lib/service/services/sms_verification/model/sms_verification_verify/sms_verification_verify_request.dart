import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verification_verify_request.freezed.dart';
part 'sms_verification_verify_request.g.dart';

@freezed
class SmsVerificationVerifyRequest with _$SmsVerificationVerifyRequest {
  const factory SmsVerificationVerifyRequest({
    required String code,
  }) = _SmsVerificationVerifyRequest;

  factory SmsVerificationVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$SmsVerificationVerifyRequestFromJson(json);
}
