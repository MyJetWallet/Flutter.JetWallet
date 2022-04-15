import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/decimal_serialiser.dart';

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
    BuyInfo? buyInfo,
    WithdrawalFeeInfo? withdrawalFeeInfo,
    TransferByPhoneInfo? transferByPhoneInfo,
    ReceiveByPhoneInfo? receiveByPhoneInfo,
    required String operationId,
    required OperationType operationType,
    required String assetId,
    required String timeStamp,
    @DecimalSerialiser() required Decimal balanceChange,
    @DecimalSerialiser() required Decimal newBalance,
    @DecimalSerialiser() required Decimal assetPriceInUsd,
    required Status status,
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
  @JsonValue(8)
  paidInterestRate,
  @JsonValue(10)
  feeSharePayment,
  @JsonValue(11)
  rewardPayment,
  @JsonValue(12)
  simplexBuy,
  @JsonValue(13)
  recurringBuy,
  unknown,
  buy,
  sell,
}

enum Status {
  @JsonValue(0)
  completed,
  @JsonValue(1)
  inProgress,
  @JsonValue(2)
  declined,
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
    @DecimalSerialiser() required Decimal withdrawalAmount,
    @DecimalSerialiser() required Decimal feeAmount,
    required bool isInternal,
  }) = _WithdrawalInfo;

  factory WithdrawalInfo.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalInfoFromJson(json);
}

@freezed
class BuyInfo with _$BuyInfo {
  const factory BuyInfo({
    String? txId,
    String? feeAssetId,
    required String sellAssetId,
    required String buyAssetId,
    @DecimalSerialiser() required Decimal sellAmount,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal feeAmount,
  }) = _BuyInfo;

  factory BuyInfo.fromJson(Map<String, dynamic> json) =>
      _$BuyInfoFromJson(json);
}

@freezed
class SwapInfo with _$SwapInfo {
  const factory SwapInfo({
    required bool isSell,
    required String sellAssetId,
    required String buyAssetId,
    required String feeAsset,
    @DecimalSerialiser() required Decimal sellAmount,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal baseRate,
    @DecimalSerialiser() required Decimal quoteRate,
    @DecimalSerialiser() required Decimal feeAmount,
    @DecimalSerialiser() @JsonKey(name: 'feePerc') required Decimal feePercent,
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

@freezed
class TransferByPhoneInfo with _$TransferByPhoneInfo {
  const factory TransferByPhoneInfo({
    String? toPhoneNumber,
    String? receiverName,
    required String withdrawalAssetId,
    required double withdrawalAmount,
  }) = _TransferByPhoneInfo;

  factory TransferByPhoneInfo.fromJson(Map<String, dynamic> json) =>
      _$TransferByPhoneInfoFromJson(json);
}

@freezed
class ReceiveByPhoneInfo with _$ReceiveByPhoneInfo {
  const factory ReceiveByPhoneInfo({
    String? fromPhoneNumber,
    String? senderName,
    required double depositAmount,
  }) = _ReceiveByPhoneInfo;

  factory ReceiveByPhoneInfo.fromJson(Map<String, dynamic> json) =>
      _$ReceiveByPhoneInfoFromJson(json);
}
