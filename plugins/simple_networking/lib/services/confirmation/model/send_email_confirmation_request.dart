import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_email_confirmation_request.freezed.dart';
part 'send_email_confirmation_request.g.dart';

@freezed
class SendEmailConfirmationRequest with _$SendEmailConfirmationRequest {
  factory SendEmailConfirmationRequest({
    required String language,
    required String deviceType,
    required int reason,
    required int type,
  }) = _SendEmailConfirmationRequest;

  factory SendEmailConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$SendEmailConfirmationRequestFromJson(json);
}
