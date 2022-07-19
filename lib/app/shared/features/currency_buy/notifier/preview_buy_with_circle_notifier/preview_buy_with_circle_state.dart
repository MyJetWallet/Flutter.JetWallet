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
    @Default(0) int depositId,
    @Default('') String cvv,
    @Default('') String currencySymbol,
    required StackLoaderNotifier loader,
  }) = _PreviewBuyWithCircleState;
}
