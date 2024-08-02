import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_verify_request_model.freezed.dart';
part 'phone_verification_verify_request_model.g.dart';

@freezed
class PhoneVerificationVerifyRequestModel with _$PhoneVerificationVerifyRequestModel {
  const factory PhoneVerificationVerifyRequestModel({
    required String code,
    required String phoneBody,
    required String phoneCode,
    required String phoneIso,
  }) = _PhoneVerificationVerifyRequestModel;

  factory PhoneVerificationVerifyRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PhoneVerificationVerifyRequestModelFromJson(json);
}
