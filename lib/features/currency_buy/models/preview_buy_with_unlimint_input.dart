import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'preview_buy_with_unlimint_input.freezed.dart';

@freezed
class PreviewBuyWithUnlimintInput with _$PreviewBuyWithUnlimintInput {
  const factory PreviewBuyWithUnlimintInput({
    required String amount,
    required CurrencyModel currency,
    required CurrencyModel currencyPayment,
    required String quickAmount,
    CircleCard? card,
  }) = _PreviewBuyWithUnlimintInput;
}
