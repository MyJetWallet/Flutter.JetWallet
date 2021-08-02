import 'package:freezed_annotation/freezed_annotation.dart';


import 'convert_union.dart';

part 'convert_state.freezed.dart';

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
    @Default(QuoteLoading()) ConvertUnion union,
    @Default(0) int timer,
  }) = _ConvertState;
}
