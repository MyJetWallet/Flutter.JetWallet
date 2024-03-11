import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_resend_code_request_model.freezed.dart';
part 'transfer_resend_code_request_model.g.dart';

@freezed
class TransferResendCodeRequestModel with _$TransferResendCodeRequestModel {
  factory TransferResendCodeRequestModel({
    required String transactionId,
  }) = _TransferResendCodeRequestModel;

  factory TransferResendCodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransferResendCodeRequestModelFromJson(json);
}
