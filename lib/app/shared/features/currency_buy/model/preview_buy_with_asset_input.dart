import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../models/currency_model.dart';

part 'preview_buy_with_asset_input.freezed.dart';

@freezed
class PreviewBuyWithAssetInput with _$PreviewBuyWithAssetInput {
  const factory PreviewBuyWithAssetInput({
    required String amount,
    required CurrencyModel fromCurrency,
    required CurrencyModel toCurrency,
    required RecurringBuysType recurringType,
  }) = _PreviewBuyWithAssetInput;
}
