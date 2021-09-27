import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_verification_request.freezed.dart';
part 'two_fa_verification_request.g.dart';

@freezed
class TwoFaVerificationRequest with _$TwoFaVerificationRequest {
  const factory TwoFaVerificationRequest({
    required String language,
    required String deviceType,
  }) = _TwoFaVerificationRequest;

  factory TwoFaVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFaVerificationRequestFromJson(json);
}
