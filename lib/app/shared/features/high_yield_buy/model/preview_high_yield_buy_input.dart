import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../models/currency_model.dart';

part 'preview_high_yield_buy_input.freezed.dart';

@freezed
class PreviewHighYieldBuyInput with _$PreviewHighYieldBuyInput {
  const factory PreviewHighYieldBuyInput({
    required String amount,
    required String apy,
    required String expectedYearlyProfit,
    required String expectedYearlyProfitBase,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
    required EarnOfferModel earnOffer,
  }) = _PreviewHighYieldBuyInput;
}
