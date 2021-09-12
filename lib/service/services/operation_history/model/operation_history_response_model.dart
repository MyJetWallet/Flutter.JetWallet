import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_history_response_model.freezed.dart';

part 'operation_history_response_model.g.dart';

@freezed
class OperationHistoryResponseModel with _$OperationHistoryResponseModel {
  const factory OperationHistoryResponseModel({
    @JsonKey(name: 'data') required List<OperationHistoryItem> operationHistory,
  }) = _OperationHistoryResponseModel;

  factory OperationHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OperationHistoryResponseModelFromJson(json);
}

@freezed
class OperationHistoryItem with _$OperationHistoryItem {
  const factory OperationHistoryItem({
    DepositInfo? depositInfo,
    WithdrawalInfo? withdrawalInfo,
    SwapInfo? swapInfo,
    WithdrawalFeeInfo? withdrawalFeeInfo,
    required String operationId,
    required OperationType operationType,
    required String assetId,
    required String timeStamp,
    required double balanceChange,
    required double newBalance,
    required int status,
  }) = _OperationHistoryItem;

  factory OperationHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$OperationHistoryItemFromJson(json);
}

enum OperationType {
  @JsonValue(0)
  deposit,
  @JsonValue(1)
  withdraw,
  @JsonValue(2)
  swap,
  @JsonValue(4)
  withdrawalFee,
  @JsonValue(6)
  transferByPhone,
  @JsonValue(7)
  receiveByPhone,
  @JsonValue(3)
  unknown,
}

@freezed
class DepositInfo with _$DepositInfo {
  const factory DepositInfo({
    String? txId,
    required double depositAmount,
  }) = _DepositInfo;

  factory DepositInfo.fromJson(Map<String, dynamic> json) =>
      _$DepositInfoFromJson(json);
}

@freezed
class WithdrawalInfo with _$WithdrawalInfo {
  const factory WithdrawalInfo({
    String? txId,
    String? toAddress,
    String? feeAssetId,
    required String withdrawalAssetId,
    required double withdrawalAmount,
    required double feeAmount,
  }) = _WithdrawalInfo;

  factory WithdrawalInfo.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalInfoFromJson(json);
}

@freezed
class SwapInfo with _$SwapInfo {
  const factory SwapInfo({
    required String sellAssetId,
    required double sellAmount,
    required String buyAssetId,
    required double buyAmount,
  }) = _SwapInfo;

  factory SwapInfo.fromJson(Map<String, dynamic> json) =>
      _$SwapInfoFromJson(json);
}

@freezed
class WithdrawalFeeInfo with _$WithdrawalFeeInfo {
  const factory WithdrawalFeeInfo({
    required String feeAssetId,
    required double feeAmount,
  }) = _WithdrawalFeeInfo;

  factory WithdrawalFeeInfo.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFeeInfoFromJson(json);
}
