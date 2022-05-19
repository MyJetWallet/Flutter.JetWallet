import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/high_yield/model/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';
import '../../../helpers/formatting/base/market_format.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';

part 'high_yield_buy_state.freezed.dart';

@freezed
class HighYieldBuyState with _$HighYieldBuyState {
  const factory HighYieldBuyState({
    Decimal? targetConversionPrice,
    BaseCurrencyModel? baseCurrency,
    CurrencyModel? selectedCurrency,
    SKeyboardPreset? selectedPreset,
    @Default('0') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default(InputError.none) InputError inputError,
    @Default('') String offerId,
    @Default([]) List<TierModel> tiers,
    Decimal? amount,
    Decimal? apy,
    Decimal? currentApy,
    Decimal? currentBalance,
    Decimal? expectedYearlyProfit,
    Decimal? expectedYearlyProfitBaseAsset,
    @Default(false) bool amountTooLarge,
    @Default(false) bool amountTooLow,
    Decimal? maxSubscribeAmount,
    Decimal? minSubscribeAmount,
  }) = _HighYieldBuyState;

  const HighYieldBuyState._();

  String get selectedCurrencySymbol {
    if (selectedCurrency == null) {
      return baseCurrency!.symbol;
    } else {
      return selectedCurrency!.symbol;
    }
  }

  int get selectedCurrencyAccuracy {
    if (selectedCurrency == null) {
      return baseCurrency!.accuracy;
    } else {
      return selectedCurrency!.accuracy;
    }
  }

  bool get singleTier => simpleTiers.length == 1;

  List<SimpleTierModel> get simpleTiers => tiers
      .map(
        (tier) => SimpleTierModel(
          active: tier.active,
          toUsd: tier.toUsd.toString(),
          fromUsd: tier.fromUsd.toString(),
          apy: tier.apy.toString(),
        ),
      )
      .toList();

  String conversionText() {
    final base = marketFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency?.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    return base;
  }
}
