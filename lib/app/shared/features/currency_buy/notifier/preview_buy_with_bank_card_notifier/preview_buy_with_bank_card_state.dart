import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'preview_buy_with_bank_card_state.freezed.dart';

@freezed
class PreviewBuyWithBankCardState with _$PreviewBuyWithBankCardState {
  const factory PreviewBuyWithBankCardState({
    Decimal? amountToGet,
    Decimal? amountToPay,
    Decimal? feeAmount,
    Decimal? feePercentage,
    Decimal? paymentAmount,
    String? paymentAsset,
    Decimal? buyAmount,
    String? buyAsset,
    Decimal? depositFeeAmount,
    String? depositFeeAsset,
    Decimal? tradeFeeAmount,
    String? tradeFeeAsset,
    Decimal? rate,
    @Default('') String paymentId,
    @Default('') String currencySymbol,
    @Default('') String cvv,
    @Default(false) bool isChecked,
    @Default(false) bool wasAction,
    @Default(false) bool isWaitingSkipped,
    required StackLoaderNotifier loader,
  }) = _PreviewBuyWithBankCardState;
}
