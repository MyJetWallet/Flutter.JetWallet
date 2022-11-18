import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_referral_code_request_model.freezed.dart';
part 'validate_referral_code_request_model.g.dart';

@freezed
class ValidateReferralCodeRequestModel with _$ValidateReferralCodeRequestModel {
  const factory ValidateReferralCodeRequestModel({
    @JsonKey(name: 'refCode') required String referralCode,
  }) = _ValidateReferralCodeRequestModel;

  factory ValidateReferralCodeRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ValidateReferralCodeRequestModelFromJson(json);
}
