import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

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
