import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/services/signal_r/model/asset_model.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    String? prefixSymbol,
    @Default('') String symbol,
    @Default('') String description,
    @Default(0) int accuracy,
    @Default(0) int depositMode,
    @Default(0) int withdrawalMode,
    @Default(TagType.none) TagType tagType,
    @Default(AssetType.crypto) AssetType type,
    @Default(AssetFeesModel()) AssetFeesModel fees,
    @Default([]) List<DepositMethods> depositMethods,
    @Default([]) List<WithdrawalMethods> withdrawalMethods,
    @Default('') String assetId,
    @Default(0.0) double reserve,
    @Default('') String lastUpdate,
    @Default(0.0) double sequenceId,
    @Default(0.0) double assetBalance,
    @Default(0.0) double baseBalance,
    @Default('') String iconUrl,
    @Default(0.0) double currentPrice,
    @Default(0.0) double dayPriceChange,
    @Default(0.0) double dayPercentChange,
  }) = _CurrencyModel;

  const CurrencyModel._();

  bool get isDepositMode => depositMode == 0;

  bool get isWithdrawalMode => withdrawalMode == 0;

  bool get isAssetBalanceEmpty => assetBalance == 0;

  bool get isAssetBalanceNotEmpty => assetBalance != 0;

  double get withdrawalFeeSize => fees.withdrawalFee?.size ?? 0;

  String get withdrawalFeeWithSymbol {
    if (withdrawalFeeSize == 0) {
      return '0 $symbol';
    } else {
      return '$withdrawalFeeSize ${fees.withdrawalFee?.assetSymbol}';
    }
  }

  bool get isFeeInOtherCurrency => symbol != fees.withdrawalFee?.assetSymbol;

  bool get hasTag => tagType != TagType.none;
}
