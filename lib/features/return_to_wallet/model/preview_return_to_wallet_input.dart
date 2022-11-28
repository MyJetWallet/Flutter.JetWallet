import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

part 'preview_return_to_wallet_input.freezed.dart';

@freezed
class PreviewReturnToWalletInput with _$PreviewReturnToWalletInput {
  const factory PreviewReturnToWalletInput({
    required String amount,
    required String remainingBalance,
    required String apy,
    required String expectedYearlyProfit,
    required String expectedYearlyProfitBase,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
    required EarnOfferModel earnOffer,
  }) = _PreviewReturnToWalletInput;
}
