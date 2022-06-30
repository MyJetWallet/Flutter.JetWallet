import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_email_confirmation_response.freezed.dart';
part 'send_email_confirmation_response.g.dart';

@freezed
class SendEmailConfirmationResponse with _$SendEmailConfirmationResponse {
  factory SendEmailConfirmationResponse({
    final String? tokenId,
    final String? verificationId,
  }) = _SendEmailConfirmationResponse;

  factory SendEmailConfirmationResponse.fromJson(Map<String, dynamic> json) =>
      _$SendEmailConfirmationResponseFromJson(json);
}
