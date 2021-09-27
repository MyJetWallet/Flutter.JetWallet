import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verification_request.freezed.dart';
part 'sms_verification_request.g.dart';

@freezed
class SmsVerificationRequest with _$SmsVerificationRequest {
  const factory SmsVerificationRequest({
    required String language,
    required String deviceType,
  }) = _SmsVerificationRequest;

  factory SmsVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SmsVerificationRequestFromJson(json);
}
