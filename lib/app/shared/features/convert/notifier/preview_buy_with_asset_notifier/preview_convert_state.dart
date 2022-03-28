import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'preview_convert_union.dart';

part 'preview_convert_state.freezed.dart';

@freezed
class PreviewConvertState with _$PreviewConvertState {
  const factory PreviewConvertState({
    String? operationId,
    Decimal? price,
    String? fromAssetSymbol,
    String? toAssetSymbol,
    Decimal? fromAssetAmount,
    Decimal? toAssetAmount,
    String? feeAsset,
    Decimal? feeAmount,
    Decimal? feePercent,
    // Will be initialzied on initState of the parent widget
    AnimationController? timerAnimation,
    // [true] when requestQuote() takes too long
    @Default(false) bool connectingToServer,
    @Default(QuoteLoading()) PreviewConvertUnion union,
    @Default(0) int timer,
  }) = _PreviewConvertState;
}
