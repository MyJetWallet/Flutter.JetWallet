import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_preview_response_model.freezed.dart';

part 'withdraw_preview_response_model.g.dart';

@freezed
class WithdrawPreviewResponseModel with _$WithdrawPreviewResponseModel {
  const factory WithdrawPreviewResponseModel({
    required String asset,
    required String feeAsset,
    required double amount,
    required double feeAmount,
  }) = _WithdrawPreviewResponseModel;

  factory WithdrawPreviewResponseModel.fromJson(Map<String, dynamic> json) => _$WithdrawPreviewResponseModelFromJson(json);
}
