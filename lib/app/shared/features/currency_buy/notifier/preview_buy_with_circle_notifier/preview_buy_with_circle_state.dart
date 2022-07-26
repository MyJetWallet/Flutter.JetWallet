import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';

part 'preview_buy_with_circle_state.freezed.dart';

@freezed
class PreviewBuyWithCircleState with _$PreviewBuyWithCircleState {
  const factory PreviewBuyWithCircleState({
    @Default(false) bool wasPending,
    @Default(false) bool isPending,
    @Default(false) bool failureShowed,
    CircleCard? card,
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
    @Default('') String cvv,
    @Default('') String currencySymbol,
    @Default(false) bool isChecked,
    required StackLoaderNotifier loader,
  }) = _PreviewBuyWithCircleState;
}
