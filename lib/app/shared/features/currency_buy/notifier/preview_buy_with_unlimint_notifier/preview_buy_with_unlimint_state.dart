import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'preview_buy_with_unlimint_state.freezed.dart';

@freezed
class PreviewBuyWithUnlimintState with _$PreviewBuyWithUnlimintState {
  const factory PreviewBuyWithUnlimintState({
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
    @Default(false) bool isChecked,
    required StackLoaderNotifier loader,
  }) = _PreviewBuyWithUnlimintState;
}
