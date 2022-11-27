import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

part 'high_yield_buy_input.freezed.dart';

@freezed
class HighYieldBuyInput with _$HighYieldBuyInput {
  const factory HighYieldBuyInput({
    required CurrencyModel currency,
    required EarnOfferModel earnOffer,
  }) = _HighYieldBuyInput;
}
