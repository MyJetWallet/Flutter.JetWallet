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
    required int weight,
    required TagType tagType,
    @JsonKey(name: 'assetType') required AssetType type,
    required AssetFeesModel fees,
    required List<String> depositBlockchains,
    required List<String> withdrawalBlockchains,
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
    @JsonKey(name: 'feeType') required FeeType type,
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
  @JsonValue(0)
  percentage,
  @JsonValue(1)
  fix,
}

enum DepositMethods {
  @JsonValue('CryptoDeposit')
  cryptoDeposit,
  @JsonValue('BlockchainReceive')
  blockchainReceive,
  @JsonValue('SepaDeposit')
  sepaDeposit,
  @JsonValue('SwiftDeposit')
  swiftDeposit,
  @JsonValue('CardDeposit')
  cardDeposit,
}

enum WithdrawalMethods {
  @JsonValue('BlockchainSend')
  blockchainSend,
  @JsonValue('CryptoWithdrawal')
  cryptoWithdrawal,
  @JsonValue('SepaWithdrawal')
  sepaWithdrawal,
  @JsonValue('SwiftWithdrawal')
  swiftWithdrawal,
}
