import 'package:freezed_annotation/freezed_annotation.dart';

import 'preview_buy_with_asset_union.dart';

part 'preview_buy_with_asset_state.freezed.dart';

@freezed
class ConvertState with _$ConvertState {
  const factory ConvertState({
    String? operationId,
    double? price,
    String? fromAssetSymbol,
    String? toAssetSymbol,
    double? fromAssetAmount,
    double? toAssetAmount,
    // [true] when requestQuote() takes too long
    @Default(false) bool connectingToServer,
    @Default(QuoteLoading()) PreviewBuyWithAssetUnion union,
    @Default(0) int timer,
  }) = _ConvertState;
}
