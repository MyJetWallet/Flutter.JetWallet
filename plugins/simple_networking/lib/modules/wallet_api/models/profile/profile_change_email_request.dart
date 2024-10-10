import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_change_email_request.freezed.dart';
part 'profile_change_email_request.g.dart';

@freezed
class ProfileChangeEmailRequest with _$ProfileChangeEmailRequest {
  factory ProfileChangeEmailRequest({
    required bool isSuccess,
    required String verificationToken,
  }) = _ProfileChangeEmailRequest;

  factory ProfileChangeEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileChangeEmailRequestFromJson(json);
}
