import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
import 'preview_buy_with_asset_union.dart';

part 'preview_buy_with_asset_state.freezed.dart';

@freezed
class PreviewBuyWithAssetState with _$PreviewBuyWithAssetState {
  const factory PreviewBuyWithAssetState({
    String? operationId,
    Decimal? price,
    String? fromAssetSymbol,
    String? toAssetSymbol,
    Decimal? fromAssetAmount,
    Decimal? toAssetAmount,
    Decimal? feePercent,
    RecurringBuyInfoModel? recurringBuyInfo,
    // Will be initialzied on initState of the parent widget
    AnimationController? timerAnimation,
    // [true] when requestQuote() takes too long
    @Default(false) bool connectingToServer,
    @Default(QuoteLoading()) PreviewBuyWithAssetUnion union,
    @Default(0) int timer,
    @Default(RecurringBuysType.oneTimePurchase) RecurringBuysType recurringType,
  }) = _ConvertState;
}
