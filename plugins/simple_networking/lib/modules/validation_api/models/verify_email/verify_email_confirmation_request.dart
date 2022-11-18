import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_confirmation_request.freezed.dart';
part 'verify_email_confirmation_request.g.dart';

@freezed
class VerifyEmailConfirmationRequest with _$VerifyEmailConfirmationRequest {
  factory VerifyEmailConfirmationRequest({
    String? tokenId,
    String? verificationId,
    String? code,
  }) = _VerifyEmailConfirmationRequest;

  factory VerifyEmailConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailConfirmationRequestFromJson(json);
}
