import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/services/signal_r/model/asset_model.dart';
import '../helpers/format_currency_amount.dart';
import '../providers/base_currency_pod/base_currency_model.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    String? prefixSymbol,
    @Default('unknown') String symbol,
    @Default('unknown') String description,
    @Default(0) int accuracy,
    @Default(0) int depositMode,
    @Default(0) int withdrawalMode,
    @Default(TagType.none) TagType tagType,
    @Default(AssetType.crypto) AssetType type,
    @Default(AssetFeesModel()) AssetFeesModel fees,
    @Default([]) List<DepositMethods> depositMethods,
    @Default([]) List<WithdrawalMethods> withdrawalMethods,
    @Default('unknown') String assetId,
    @Default(0.0) double reserve,
    @Default('unknown') String lastUpdate,
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

  String get emptyWithdrawalFee => '0 $symbol';

  bool get isFeeInOtherCurrency => symbol != fees.withdrawalFee?.assetSymbol;

  bool get hasTag => tagType != TagType.none;

  String formatBaseBalance(BaseCurrencyModel baseCurrency) {
    return formatCurrencyAmount(
      prefix: baseCurrency.prefix,
      value: baseBalance,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
  }

  String get formattedAssetBalance {
    return formatCurrencyAmount(
      prefix: prefixSymbol,
      value: assetBalance,
      accuracy: accuracy,
      symbol: symbol,
    );
  }

  bool get supportsAtLeastOneFiatDepositMethod {
    return supportsCardDeposit || supportsSepaDeposit || supportsSwiftDeposit;
  }

  bool get supportsCryptoDeposit {
    return depositMethods.contains(DepositMethods.cryptoDeposit);
  }

  bool get supportsCardDeposit {
    return depositMethods.contains(DepositMethods.cardDeposit);
  }

  bool get supportsSepaDeposit {
    return depositMethods.contains(DepositMethods.sepaDeposit);
  }

  bool get supportsSwiftDeposit {
    return depositMethods.contains(DepositMethods.swiftDeposit);
  }

  bool get supportsAtLeastOneWithdrawalMethod {
    return supportsCryptoWithdrawal ||
        supportsSepaWithdrawal ||
        supportsSWiftWithdrawal;
  }

  bool get supportsCryptoWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.cryptoWithdrawal);
  }

  bool get supportsSepaWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.sepaWithdrawal);
  }

  bool get supportsSWiftWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.swiftWithdrawal);
  }
}
