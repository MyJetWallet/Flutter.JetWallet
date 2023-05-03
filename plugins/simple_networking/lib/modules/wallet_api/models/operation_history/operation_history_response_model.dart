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
    @OperationTypeSerialiser() required OperationType operationType,
    required String assetId,
    required String timeStamp,
    @DecimalSerialiser() required Decimal balanceChange,
    @DecimalSerialiser() required Decimal newBalance,
    @DecimalSerialiser() required Decimal assetPriceInUsd,
    @StatusSerialiser() required Status status,
  }) = _OperationHistoryItem;

  factory OperationHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$OperationHistoryItemFromJson(json);
}

enum OperationType {
  deposit,
  withdraw,
  swap,
  withdrawalFee,
  transferByPhone,
  receiveByPhone,
  paidInterestRate,
  feeSharePayment,
  rewardPayment,
  simplexBuy,
  recurringBuy,
  earningDeposit,
  earningWithdrawal,
  cryptoInfo,
  unknown,
  buy,
  sell,
  nftSwap,
  nftReserve,
  nftRelease,
  nftBuy,
  nftBuyOpposite,
  nftSell,
  nftSellOpposite,
  nftDeposit,
  nftWithdrawal,
  nftWithdrawalFee,
  manualDeposit,
  manualWithdrawal,
  transferByNickname,
  receiveByNickname,
  ibanDeposit,
  buyApplePay,
  buyGooglePay,
  ibanSend,
  sendGlobally
}

extension _OperationTypeExtension on OperationType {
  int get name {
    switch (this) {
      case OperationType.deposit:
        return 0;
      case OperationType.withdraw:
        return 1;
      case OperationType.swap:
        return 2;
      case OperationType.withdrawalFee:
        return 4;
      case OperationType.transferByPhone:
        return 6;
      case OperationType.receiveByPhone:
        return 7;
      case OperationType.paidInterestRate:
        return 8;
      case OperationType.feeSharePayment:
        return 10;
      case OperationType.rewardPayment:
        return 11;
      case OperationType.simplexBuy:
        return 12;
      case OperationType.recurringBuy:
        return 13;
      case OperationType.earningDeposit:
        return 14;
      case OperationType.earningWithdrawal:
        return 15;
      case OperationType.cryptoInfo:
        return 17;
      case OperationType.buy:
        return 0;
      case OperationType.sell:
        return 0;
      case OperationType.nftSwap:
        return 18;
      case OperationType.nftReserve:
        return 19;
      case OperationType.nftRelease:
        return 20;
      case OperationType.nftBuy:
        return 21;
      case OperationType.nftBuyOpposite:
        return 22;
      case OperationType.nftSell:
        return 23;
      case OperationType.nftSellOpposite:
        return 24;
      case OperationType.nftDeposit:
        return 25;
      case OperationType.nftWithdrawal:
        return 26;
      case OperationType.nftWithdrawalFee:
        return 27;
      case OperationType.manualDeposit:
        return 28;
      case OperationType.manualWithdrawal:
        return 29;
      case OperationType.transferByNickname:
        return 30;
      case OperationType.receiveByNickname:
        return 31;
      case OperationType.ibanDeposit:
        return 32;
      case OperationType.buyApplePay:
        return 34;
      case OperationType.buyGooglePay:
        return 35;
      case OperationType.ibanSend:
        return 36;
      case OperationType.sendGlobally:
        return 37;
      default:
        return 0;
    }
  }
}

class OperationTypeSerialiser implements JsonConverter<OperationType, dynamic> {
  const OperationTypeSerialiser();

  @override
  OperationType fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return OperationType.deposit;
    } else if (value == '1') {
      return OperationType.withdraw;
    } else if (value == '2') {
      return OperationType.swap;
    } else if (value == '4') {
      return OperationType.withdrawalFee;
    } else if (value == '6') {
      return OperationType.transferByPhone;
    } else if (value == '7') {
      return OperationType.receiveByPhone;
    } else if (value == '8') {
      return OperationType.paidInterestRate;
    } else if (value == '10') {
      return OperationType.feeSharePayment;
    } else if (value == '11') {
      return OperationType.rewardPayment;
    } else if (value == '12') {
      return OperationType.simplexBuy;
    } else if (value == '13') {
      return OperationType.recurringBuy;
    } else if (value == '14') {
      return OperationType.earningDeposit;
    } else if (value == '15') {
      return OperationType.earningWithdrawal;
    } else if (value == '17') {
      return OperationType.cryptoInfo;
    } else if (value == 'unknown') {
      return OperationType.unknown;
    } else if (value == 'buy') {
      return OperationType.buy;
    } else if (value == 'sell') {
      return OperationType.sell;
    } else if (value == '18') {
      return OperationType.nftSwap;
    } else if (value == '19') {
      return OperationType.nftReserve;
    } else if (value == '20') {
      return OperationType.nftRelease;
    } else if (value == '21') {
      return OperationType.nftBuy;
    } else if (value == '22') {
      return OperationType.nftBuyOpposite;
    } else if (value == '23') {
      return OperationType.nftSell;
    } else if (value == '24') {
      return OperationType.nftSellOpposite;
    } else if (value == '25') {
      return OperationType.nftDeposit;
    } else if (value == '26') {
      return OperationType.nftWithdrawal;
    } else if (value == '27') {
      return OperationType.nftWithdrawalFee;
    } else if (value == '28') {
      return OperationType.manualDeposit;
    } else if (value == '29') {
      return OperationType.manualWithdrawal;
    } else if (value == '30') {
      return OperationType.transferByNickname;
    } else if (value == '31') {
      return OperationType.receiveByNickname;
    } else if (value == '32') {
      return OperationType.ibanDeposit;
    } else if (value == '34') {
      return OperationType.buyApplePay;
    } else if (value == '35') {
      return OperationType.buyGooglePay;
    } else if (value == '36') {
      return OperationType.ibanSend;
    } else if (value == '37') {
      return OperationType.sendGlobally;
    } else {
      return OperationType.unknown;
    }
  }

  @override
  dynamic toJson(OperationType type) => type.name;
}

enum Status {
  @JsonValue(0)
  completed,
  @JsonValue(1)
  inProgress,
  @JsonValue(2)
  declined,
}

extension _StatusExtension on Status {
  int get name {
    switch (this) {
      case Status.completed:
        return 0;
      case Status.inProgress:
        return 1;
      case Status.declined:
        return 2;
      default:
        return 0;
    }
  }
}

class StatusSerialiser implements JsonConverter<Status, dynamic> {
  const StatusSerialiser();

  @override
  Status fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return Status.completed;
    } else if (value == '1') {
      return Status.inProgress;
    } else {
      return Status.declined;
    }
  }

  @override
  dynamic toJson(Status type) => type.name;
}

@freezed
class DepositInfo with _$DepositInfo {
  const factory DepositInfo({
    String? txId,
    String? network,
    String? address,
    String? tag,
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
    String? cardLast4,
    String? receiveAsset,
    String? contactName,
    @DecimalNullSerialiser() Decimal? receiveAmount,
    @DecimalNullSerialiser() Decimal? receiveRate,
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
