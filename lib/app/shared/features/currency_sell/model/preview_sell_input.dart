import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'preview_sell_input.freezed.dart';

@freezed
class PreviewSellInput with _$PreviewSellInput {
  const factory PreviewSellInput({
    required String amount,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
  }) = _PreviewSellInput;
}
