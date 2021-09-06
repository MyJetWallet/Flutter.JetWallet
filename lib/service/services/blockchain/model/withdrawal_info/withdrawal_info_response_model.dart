import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_info_response_model.freezed.dart';
part 'withdrawal_info_response_model.g.dart';

@freezed
class WithdrawalInfoResponseModel with _$WithdrawalInfoResponseModel {
  const factory WithdrawalInfoResponseModel({
    String? feeAssetSymbol,
    // id of the transaction in blockchain
    @JsonKey(name: 'txid') String? blockchainId,
    required String toAddress,
    required double amount,
    required double feeAmount,
    required String assetSymbol,
    // id of the transaction in the spot platform
    @JsonKey(name: 'id') required String transactionId,
    required WithdrawalStatus status,
  }) = _WithdrawalInfoResponseModel;

  factory WithdrawalInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalInfoResponseModelFromJson(json);
}

enum WithdrawalStatus {
  @JsonValue(0)
  pendingApproval,
  @JsonValue(1)
  success,
  @JsonValue(2)
  fail,
}
