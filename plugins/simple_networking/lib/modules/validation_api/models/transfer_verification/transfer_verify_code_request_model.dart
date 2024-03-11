import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_verify_code_request_model.freezed.dart';
part 'transfer_verify_code_request_model.g.dart';

@freezed
class TransferVerifyCodeRequestModel with _$TransferVerifyCodeRequestModel {
  factory TransferVerifyCodeRequestModel({
    required String transactionId,
    required String code,
  }) = _TransferVerifyCodeRequestModel;

  factory TransferVerifyCodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransferVerifyCodeRequestModelFromJson(json);
}
