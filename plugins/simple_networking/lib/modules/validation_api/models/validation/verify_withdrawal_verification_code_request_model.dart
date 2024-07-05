import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_withdrawal_verification_code_request_model.freezed.dart';
part 'verify_withdrawal_verification_code_request_model.g.dart';

@freezed
class VerifyWithdrawalVerificationCodeRequestModel with _$VerifyWithdrawalVerificationCodeRequestModel {
  const factory VerifyWithdrawalVerificationCodeRequestModel({
    required String code,
    required String operationId,
    required String brand,
  }) = _VerifyWithdrawalVerificationCodeRequestModel;

  factory VerifyWithdrawalVerificationCodeRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$VerifyWithdrawalVerificationCodeRequestModelFromJson(json);
}
