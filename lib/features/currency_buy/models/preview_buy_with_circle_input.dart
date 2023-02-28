import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'preview_buy_with_circle_input.freezed.dart';

@freezed
class PreviewBuyWithCircleInput with _$PreviewBuyWithCircleInput {
  const factory PreviewBuyWithCircleInput({
    required bool fromCard,
    required String amount,
    required CircleCard card,
    required CurrencyModel currency,
    required CurrencyModel currencyPayment,
    required String quickAmount,
  }) = _PreviewBuyWithAssetInput;
}
