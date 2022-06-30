import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_confirmation_request.freezed.dart';
part 'verify_email_confirmation_request.g.dart';

@freezed
class VerifyEmailConfirmationRequest with _$VerifyEmailConfirmationRequest {
  factory VerifyEmailConfirmationRequest({
    final String? tokenId,
    final String? verificationId,
    final String? code,
  }) = _VerifyEmailConfirmationRequest;

  factory VerifyEmailConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailConfirmationRequestFromJson(json);
}
