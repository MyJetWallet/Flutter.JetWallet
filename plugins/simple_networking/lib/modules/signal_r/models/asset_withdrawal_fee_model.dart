import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'asset_withdrawal_fee_model.freezed.dart';
part 'asset_withdrawal_fee_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AssetWithdrawalFeeModel with _$AssetWithdrawalFeeModel {
  const factory AssetWithdrawalFeeModel({
    required List<AssetFeeModel> assetFees,
  }) = _AssetWithdrawalFeeModel;
  factory AssetWithdrawalFeeModel.fromJson(Map<String, dynamic> json) => _$AssetWithdrawalFeeModelFromJson(json);
}

@freezed
class AssetFeeModel with _$AssetFeeModel {
  const factory AssetFeeModel({
    required String asset,
    String? network,
    @DecimalSerialiser() required Decimal size,
    required FeeType feeType,
  }) = _AssetFeeModel;
  factory AssetFeeModel.fromJson(Map<String, dynamic> json) => _$AssetFeeModelFromJson(json);
}

enum FeeType {
  @JsonValue(0)
  percentage,
  @JsonValue(1)
  absolute,
  @JsonValue(2)
  composite,
}
