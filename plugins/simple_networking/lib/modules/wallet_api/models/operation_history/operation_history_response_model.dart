import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

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
    RecurringBuyInfo? recurringBuyInfo,
    CryptoBuyInfo? cryptoBuyInfo,
    EarnInfo? earnInfo,
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
  @JsonValue(14)
  earningDeposit,
  @JsonValue(15)
  earningWithdrawal,
  @JsonValue(17)
  cryptoInfo,
  unknown,
  buy,
  sell,
  @JsonValue(18)
  nftSwap,
  @JsonValue(19)
  nftReserve,
  @JsonValue(20)
  nftRelease,
  @JsonValue(21)
  nftBuy,
  @JsonValue(22)
  nftBuyOpposite,
  @JsonValue(23)
  nftSell,
  @JsonValue(24)
  nftSellOpposite,
  @JsonValue(25)
  nftDeposit,
  @JsonValue(26)
  nftWithdrawal,
  @JsonValue(27)
  nftWithdrawalFee,
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
    String? network,
    required bool isInternal,
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
    String? network,
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
    String? network,
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
    @Default('') String feeAsset,
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
    String? transferId,
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

@freezed
class RecurringBuyInfo with _$RecurringBuyInfo {
  const factory RecurringBuyInfo({
    String? sellAssetId,
    String? feeAsset,
    String? scheduleType,
    String? buyAssetId,
    @DecimalSerialiser() required Decimal sellAmount,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal baseRate,
    @DecimalSerialiser() required Decimal quoteRate,
    @DecimalSerialiser() @JsonKey(name: 'feePerc') required Decimal feePercent,
    @DecimalSerialiser() required Decimal feeAmount,
  }) = _RecurringBuyInfo;

  factory RecurringBuyInfo.fromJson(Map<String, dynamic> json) =>
      _$RecurringBuyInfoFromJson(json);
}

@freezed
class EarnInfo with _$EarnInfo {
  const factory EarnInfo({
    OfferInfo? offerInfo,
    required String withdrawalReason,
    @DecimalSerialiser() required Decimal apy,
    @DecimalSerialiser() required Decimal totalBalance,
  }) = _EarnInfo;

  factory EarnInfo.fromJson(Map<String, dynamic> json) =>
      _$EarnInfoFromJson(json);
}

@freezed
class OfferInfo with _$OfferInfo {
  const factory OfferInfo({
    String? title,
    required String offerTag,
  }) = _OfferInfo;

  factory OfferInfo.fromJson(Map<String, dynamic> json) =>
      _$OfferInfoFromJson(json);
}

@freezed
class CryptoBuyInfo with _$CryptoBuyInfo {
  const factory CryptoBuyInfo({
    required String paymentAssetId,
    @DecimalSerialiser() required Decimal paymentAmount,
    required String buyAssetId,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal baseRate,
    @DecimalSerialiser() required Decimal quoteRate,
    @DecimalSerialiser() required Decimal depositFeeAmount,
    required String depositFeeAsset,
    @DecimalSerialiser() required Decimal tradeFeeAmount,
    required String tradeFeeAsset,
    required String cardLast4,
    String? cardType,
  }) = _CryptoBuyInfo;

  factory CryptoBuyInfo.fromJson(Map<String, dynamic> json) =>
      _$CryptoBuyInfoFromJson(json);
}
