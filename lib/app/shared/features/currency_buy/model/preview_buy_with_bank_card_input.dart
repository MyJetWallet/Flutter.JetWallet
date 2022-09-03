import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'preview_buy_with_bank_card_input.freezed.dart';

@freezed
class PreviewBuyWithBankCardInput with _$PreviewBuyWithBankCardInput {
  const factory PreviewBuyWithBankCardInput({
    required String amount,
    required CurrencyModel currency,
    String? cardId,
    String? cardNumber,
    String? encKeyId,
    String? encData,
    int? expMonth,
    int? expYear,
    bool? isActive,
  }) = _PreviewBuyWithBankCardInput;
}
