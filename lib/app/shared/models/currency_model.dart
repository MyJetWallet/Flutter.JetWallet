import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/services/signal_r/model/asset_model.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    String? prefixSymbol,
    required String symbol,
    required String description,
    required int accuracy,
    required int depositMode,
    required int withdrawalMode,
    required TagType tagType,
    required AssetType type,
    required AssetFeesModel fees,
    required List<DepositMethods> depositMethods,
    required List<WithdrawalMethods> withdrawalMethods,
    required String assetId,
    required double reserve,
    required String lastUpdate,
    required double sequenceId,
    required double assetBalance,
    required double baseBalance,
    required String iconUrl,
    required double currentPrice,
    required double dayPriceChange,
    required double dayPercentChange,
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
