import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'preview_convert_input.freezed.dart';

@freezed
class PreviewConvertInput with _$PreviewConvertInput {
  const factory PreviewConvertInput({
    required String amount,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
  }) = _PreviewConvertInput;
}
