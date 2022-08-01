import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'preview_buy_with_unlimint_input.freezed.dart';

@freezed
class PreviewBuyWithUnlimintInput with _$PreviewBuyWithUnlimintInput {
  const factory PreviewBuyWithUnlimintInput({
    required String amount,
    required CurrencyModel currency,
  }) = _PreviewBuyWithUnlimintInput;
}
