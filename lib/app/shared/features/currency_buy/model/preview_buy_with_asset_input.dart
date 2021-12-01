import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/currency_model.dart';

part 'preview_buy_with_asset_input.freezed.dart';

@freezed
class PreviewBuyWithAssetInput with _$PreviewBuyWithAssetInput {
  const factory PreviewBuyWithAssetInput({
    required String amount,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
  }) = _PreviewBuyWithAssetInput;
}
