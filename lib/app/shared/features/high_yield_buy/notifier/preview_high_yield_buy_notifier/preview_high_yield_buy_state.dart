import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'preview_high_yield_buy_union.dart';

part 'preview_high_yield_buy_state.freezed.dart';

@freezed
class PreviewHighYieldBuyState with _$PreviewHighYieldBuyState {
  const factory PreviewHighYieldBuyState({
    String? operationId,
    Decimal? price,
    String? fromAssetSymbol,
    String? toAssetSymbol,
    Decimal? fromAssetAmount,
    Decimal? toAssetAmount,
    Decimal? feePercent,
    // Will be initialzied on initState of the parent widget
    AnimationController? timerAnimation,
    // [true] when requestQuote() takes too long
    @Default(false) bool connectingToServer,
    @Default(QuoteLoading()) PreviewHighYieldBuyUnion union,
    @Default(0) int timer,
    Decimal? apy,
    Decimal? expectedYearlyProfit,
    Decimal? expectedYearlyProfitBase,
  }) = _PreviewHighYieldBuyState;
}
