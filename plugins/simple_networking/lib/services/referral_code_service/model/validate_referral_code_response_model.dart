import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_referral_code_response_model.freezed.dart';

part 'validate_referral_code_response_model.g.dart';

@freezed
class ValidateReferralCodeResponseModel
    with _$ValidateReferralCodeResponseModel {
  const factory ValidateReferralCodeResponseModel({
    required String result,
  }) = _ValidateReferralCodeResponseModel;

  factory ValidateReferralCodeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ValidateReferralCodeResponseModelFromJson(json);
}
