import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_full_verify_request_model.freezed.dart';
part 'phone_verification_full_verify_request_model.g.dart';

@freezed
class PhoneVerificationFullVerifyRequestModel with _$PhoneVerificationFullVerifyRequestModel {
  const factory PhoneVerificationFullVerifyRequestModel({
    required String code,
  }) = _PhoneVerificationFullVerifyRequestModel;

  factory PhoneVerificationFullVerifyRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PhoneVerificationFullVerifyRequestModelFromJson(json);
}
