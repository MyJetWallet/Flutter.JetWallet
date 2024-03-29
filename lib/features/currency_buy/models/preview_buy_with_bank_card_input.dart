import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

part 'preview_buy_with_bank_card_input.freezed.dart';

@freezed
class PreviewBuyWithBankCardInput with _$PreviewBuyWithBankCardInput {
  const factory PreviewBuyWithBankCardInput({
    required String amount,
    required CurrencyModel currency,
    required CurrencyModel currencyPayment,
    required String quickAmount,
    @Default(false) bool isApplePay,
    @Default(false) bool isGooglePay,
    String? cardId,
    String? cardNumber,
  }) = _PreviewBuyWithBankCardInput;
}
