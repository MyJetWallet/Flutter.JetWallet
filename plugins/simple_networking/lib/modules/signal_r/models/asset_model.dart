import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AssetsModel with _$AssetsModel {
  const factory AssetsModel({
    required double now,
    required List<AssetModel> assets,
  }) = _AssetsModel;

  factory AssetsModel.fromJson(Map<String, dynamic> json) =>
      _$AssetsModelFromJson(json);
}

@freezed
class AssetModel with _$AssetModel {
  const factory AssetModel({
    String? iconUrl,
    String? prefixSymbol,
    @Default(false) bool earnProgramEnabled,
    required bool hideInTerminal,
    required String symbol,
    required String description,
    required double accuracy,
    required double normalizedAccuracy,
    required int weight,
    required TagType tagType,
    @JsonKey(name: 'assetType') required AssetType type,
    required AssetFeesModel fees,
    required List<String> depositBlockchains,
    required List<String> withdrawalBlockchains,
    @DecimalNullSerialiser() Decimal? minTradeAmount,
    @DecimalNullSerialiser() Decimal? maxTradeAmount,
    bool? walletIsActive,
    int? walletOrder,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
}

@freezed
class AssetFeesModel with _$AssetFeesModel {
  const factory AssetFeesModel({
    WithdrawalFeeModel? withdrawalFee,
  }) = _AssetFees;

  factory AssetFeesModel.fromJson(Map<String, dynamic> json) =>
      _$AssetFeesModelFromJson(json);
}

@freezed
class WithdrawalFeeModel with _$WithdrawalFeeModel {
  const factory WithdrawalFeeModel({
    @DecimalSerialiser() required Decimal size,
    @FeeTypeSerialiser() @JsonKey(name: 'feeType') required FeeType type,
    @JsonKey(name: 'asset') required String assetSymbol,
  }) = _WithdrawalFeeModel;

  factory WithdrawalFeeModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFeeModelFromJson(json);
}

enum TagType {
  @JsonValue(0)
  none,
  @JsonValue(1)
  tag,
  @JsonValue(2)
  memo,
}

enum AssetType {
  @JsonValue('Fiat')
  fiat,
  @JsonValue('Crypto')
  crypto,
  @JsonValue('Index')
  indices,
}

enum FeeType {
  percentage,
  fix,
  unsupported,
}

extension _FeeTypeExtension on FeeType {
  int get name {
    switch (this) {
      case FeeType.percentage:
        return 0;
      case FeeType.fix:
        return 1;
      default:
        return 0;
    }
  }
}

class FeeTypeSerialiser implements JsonConverter<FeeType, dynamic> {
  const FeeTypeSerialiser();

  @override
  FeeType fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return FeeType.percentage;
    } else if (value == '1') {
      return FeeType.fix;
    } else {
      return FeeType.unsupported;
    }
  }

  @override
  dynamic toJson(FeeType type) => type.name;
}

enum DepositMethods {
  cryptoDeposit,
  blockchainReceive,
  sepaDeposit,
  swiftDeposit,
  cardDeposit,
  ibanReceive,
  unsupported,
}

extension _DepositMethodsExtension on DepositMethods {
  String get name {
    switch (this) {
      case DepositMethods.cryptoDeposit:
        return 'CryptoDeposit';
      case DepositMethods.blockchainReceive:
        return 'BlockchainReceive';
      case DepositMethods.sepaDeposit:
        return 'SepaDeposit';
      case DepositMethods.swiftDeposit:
        return 'SwiftDeposit';
      case DepositMethods.cardDeposit:
        return 'CardDeposit';
      case DepositMethods.ibanReceive:
        return 'IbanReceive';
      default:
        return 'Unsupported';
    }
  }
}

class DepositMethodsSerialiser
    implements JsonConverter<DepositMethods, dynamic> {
  const DepositMethodsSerialiser();

  @override
  DepositMethods fromJson(dynamic json) {
    final value = json.toString();

    if (value == 'CryptoDeposit') {
      return DepositMethods.cryptoDeposit;
    } else if (value == 'BlockchainReceive') {
      return DepositMethods.blockchainReceive;
    } else if (value == 'SepaDeposit') {
      return DepositMethods.sepaDeposit;
    } else if (value == 'SwiftDeposit') {
      return DepositMethods.swiftDeposit;
    } else if (value == 'CardDeposit') {
      return DepositMethods.cardDeposit;
    } else if (value == 'IbanReceive') {
      return DepositMethods.ibanReceive;
    } else {
      return DepositMethods.unsupported;
    }
  }

  @override
  dynamic toJson(DepositMethods type) => type.name;
}

enum WithdrawalMethods {
  blockchainSend,
  cryptoWithdrawal,
  sepaWithdrawal,
  swiftWithdrawal,

  /// Using for gifts
  internalSend,
  ibanSend,
  globalSend,
  unsupported,
}

extension _WithdrawalMethodsExtension on WithdrawalMethods {
  String get name {
    switch (this) {
      case WithdrawalMethods.blockchainSend:
        return 'BlockchainSend';
      case WithdrawalMethods.cryptoWithdrawal:
        return 'CryptoWithdrawal';
      case WithdrawalMethods.sepaWithdrawal:
        return 'SepaWithdrawal';
      case WithdrawalMethods.swiftWithdrawal:
        return 'SwiftWithdrawal';
      case WithdrawalMethods.internalSend:
        return 'InternalSend';
      case WithdrawalMethods.ibanSend:
        return 'IbanSend';
      case WithdrawalMethods.globalSend:
        return 'GlobalSend';
      default:
        return 'Unsupported';
    }
  }
}

class WithdrawalMethodsSerialiser
    implements JsonConverter<WithdrawalMethods, dynamic> {
  const WithdrawalMethodsSerialiser();

  @override
  WithdrawalMethods fromJson(dynamic json) {
    final value = json.toString();

    if (value == 'BlockchainSend') {
      return WithdrawalMethods.blockchainSend;
    } else if (value == 'CryptoWithdrawal') {
      return WithdrawalMethods.cryptoWithdrawal;
    } else if (value == 'SepaWithdrawal') {
      return WithdrawalMethods.sepaWithdrawal;
    } else if (value == 'SwiftWithdrawal') {
      return WithdrawalMethods.swiftWithdrawal;
    } else if (value == 'InternalSend') {
      return WithdrawalMethods.internalSend;
    } else if (value == 'IbanSend') {
      return WithdrawalMethods.ibanSend;
    } else if (value == 'GlobalSend') {
      return WithdrawalMethods.globalSend;
    } else {
      return WithdrawalMethods.unsupported;
    }
  }

  @override
  dynamic toJson(WithdrawalMethods type) => type.name;
}
